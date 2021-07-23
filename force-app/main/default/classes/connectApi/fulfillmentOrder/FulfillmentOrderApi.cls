/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description Fulfill orders in Order Management
*/
public with sharing class FulfillmentOrderApi extends ConnectApiBase {
    /**
    * @description Create one or more FulfillmentOrders 
    *   and FulfillmentOrderLineItems for an OrderDeliveryGroupSummary,
    *   which defines a delivery method and recipient for an OrderSummary.
    *   You specify the OrderItemSummaries to allocate, which can be 
    *   fulfilled from different locations. Specifying multiple fulfillment
    *   groups creates one FulfillmentOrder for each location. For each 
    *   OrderItemSummary, a FulfillmentOrderLineItem is created and assigned 
    *   to the corresponding FulfillmentOrder
    *   suppress reason: ignore
    * @param orderSummaryId Id of the OrderSummary
    * @param locationId Id of the Location
    * @param fulfillmentOrderType Type of the FulfillmentOrder (enum)
    * @return A list of Ids of the created FulfillmentOrders
    */
    public ConnectApi.FulfillmentOrderOutputRepresentation createFulfillmentOrders(String orderSummaryId, String locationId, FulfillmentOrderType fulfillmentOrderType) {
        ConnectApi.FulfillmentOrderInputRepresentation fulfillmentOrderInput = new ConnectApi.FulfillmentOrderInputRepresentation();
        fulfillmentOrderInput.orderSummaryId = orderSummaryId;
        
        List<OrderDeliveryGroupSummary> orderDeliveryGroupSummaryList = [SELECT Id FROM OrderDeliveryGroupSummary WHERE OrderSummaryId =: orderSummaryId WITH SECURITY_ENFORCED];
        Map<String, List<OrderItemSummary>> orderDeliveryGroupSummaryIdToOrderItemSummaryList = getOrderItemSummaryMap(orderDeliveryGroupSummaryList);

        for (OrderDeliveryGroupSummary orderDeliveryGroupSummary: orderDeliveryGroupSummaryList) {
            fulfillmentOrderInput.orderDeliveryGroupSummaryId = orderDeliveryGroupSummary.Id;

            List<ConnectApi.FulfillmentGroupInputRepresentation> fulfillmentGroups = new List<ConnectApi.FulfillmentGroupInputRepresentation>();
            ConnectApi.FulfillmentGroupInputRepresentation fulfillmentGroup = new ConnectApi.FulfillmentGroupInputRepresentation();
            fulfillmentGroup.fulfilledFromLocationId = locationId;
            fulfillmentGroup.fulfillmentType = fulfillmentOrderType.enumValue;

            List<ConnectApi.OrderItemSummaryInputRepresentation> orderItemSummaryInputList = new List<ConnectApi.OrderItemSummaryInputRepresentation>();
            List<OrderItemSummary> orderItemSummaryList = orderDeliveryGroupSummaryIdToOrderItemSummaryList.get(orderDeliveryGroupSummary.Id);

            for(OrderItemSummary orderItemSummary : orderItemSummaryList) {
                ConnectApi.OrderItemSummaryInputRepresentation orderItemSummaryInput = new ConnectApi.OrderItemSummaryInputRepresentation();
                orderItemSummaryInput.orderItemSummaryId = orderItemSummary.Id;
                orderItemSummaryInput.quantity = orderItemSummary.Quantity;
                orderItemSummaryInputList.add(orderItemSummaryInput);
            }

            fulfillmentGroup.orderItemSummaries = orderItemSummaryInputList;
            fulfillmentGroups.add(fulfillmentGroup);
            fulfillmentOrderInput.fulfillmentGroups = fulfillmentGroups;
        }

        ConnectApi.FulfillmentOrderOutputRepresentation output = ConnectApi.FulfillmentOrder.createFulfillmentOrders(fulfillmentOrderInput);
        super.insertFailedResults(output);
        return output;
    }

    /**
    * @description Create an invoice for a FulfillmentOrder that doesn’t have one
    * @param fulfillmentOrderId of the FulfillmentOrder
    * @return Id of the created Invoice
    */
    public ConnectApi.FulfillmentOrderInvoiceOutputRepresentation createInvoice(String fulfillmentOrderId) {
        ConnectApi.FulfillmentOrderInvoiceInputRepresentation invoiceInput = new ConnectApi.FulfillmentOrderInvoiceInputRepresentation();
        ConnectAPI.FulfillmentOrderInvoiceOutputRepresentation output = ConnectApi.FulfillmentOrder.createInvoice(fulfillmentOrderId, invoiceInput);
        super.insertFailedResults(output);
        return output;
    }

    /**
    * @description Cancel FulfillmentOrderLineItems from a FulfillmentOrder. 
    * This action doesn’t cancel the associated OrderItemSummaries, so reallocate
    *  the canceled quantities to a new FulfillmentOrder
    * @param fulfillmentOrderId Id of the FulfillmentOrder
    * @param lineItemIdToCancelQuantity Map<FulfillmentOrderLineItem.Id, FulfillmentOrderLineItem.Quantity/QuantityCancelled>
    * @return Wraps the base output
    */
    public ConnectApi.FulfillmentOrderCancelLineItemsOutputRepresentation cancelFulfillmentOrderLineItems(String fulfillmentOrderId, Map<String, Decimal> lineItemIdToCancelQuantity) {
        List<ConnectApi.FulfillmentOrderLineItemInputRepresentation> cancelItemList = new List<ConnectApi.FulfillmentOrderLineItemInputRepresentation>();

        for(String fulfillmentOrderLineItemId : lineItemIdToCancelQuantity.keySet()) {
            Decimal quantityCancelled = lineItemIdToCancelQuantity.get(fulfillmentOrderLineItemId);

            ConnectApi.FulfillmentOrderLineItemInputRepresentation cancelItem = new ConnectApi.FulfillmentOrderLineItemInputRepresentation();
            cancelItem.fulfillmentOrderLineItemId = fulfillmentOrderLineItemId;
            cancelItem.quantity = quantityCancelled;
            cancelItemList.add(cancelItem);
        }

        ConnectApi.FulfillmentOrderLineItemsToCancelInputRepresentation input = new ConnectApi.FulfillmentOrderLineItemsToCancelInputRepresentation();
        input.fulfillmentOrderLineItemsToCancel = cancelItemList;

        ConnectApi.FulfillmentOrderCancelLineItemsOutputRepresentation output = ConnectAPI.FulfillmentOrder.cancelFulfillmentOrderLineItems(fulfillmentOrderId, input);
        super.insertFailedResults(output);
        return output;
    }

    /**
    * @description Create FulfillmentOrders for multiple 
    *   OrderDeliveryGroups in a single request
    *   suppress reason: ignore
    * @param createFulfillmentOrderList Input contains
    *   LocationId, OrderSummaryId, FulfillmentType
    * @return List of responses for the individual 
    *   FulfillmentOrder creation attempts from a create
    *   multiple fulfillment orders request
    */
    public ConnectApi.MultipleFulfillmentOrderOutputRepresentation createMultipleFulfillmentOrder(List<CreateFulfillmentOrderInput> createFulfillmentOrderList) {
        ConnectApi.MultipleFulfillmentOrderInputRepresentation multipleFulfillmentOrderInput = new ConnectApi.MultipleFulfillmentOrderInputRepresentation();
        multipleFulfillmentOrderInput.fulfillmentOrders = new List<ConnectApi.FulfillmentOrderInputRepresentation>();

        // prevent query in loop
        Set<Id> orderSummaryIdList = getOrderSummaryIdList(createFulfillmentOrderList);
        List<OrderDeliveryGroupSummary> orderDeliveryGroupSummaryList = [SELECT OrderSummaryId FROM OrderDeliveryGroupSummary 
                                                                        WHERE OrderSummaryId IN: orderSummaryIdList 
                                                                        WITH SECURITY_ENFORCED];
        Map<String, List<OrderDeliveryGroupSummary>> orderSummaryIdToOrderDeliveryGroupSummaryList = getOrderDeliveryGroupSummaryMap(orderDeliveryGroupSummaryList);
        Map<String, List<OrderItemSummary>> orderDeliveryGroupSummaryIdToOrderItemSummaryList = getOrderItemSummaryMap(orderDeliveryGroupSummaryList);

        for (CreateFulfillmentOrderInput createFulfillmentOrderInput : createFulfillmentOrderList) {
            String orderSummaryId = CreateFulfillmentOrderInput.orderSummaryId;
            String locationId = CreateFulfillmentOrderInput.locationId;
            String fulfillmentType = CreateFulfillmentOrderInput.fulfillmentType;

            ConnectApi.FulfillmentOrderInputRepresentation fulfillmentOrderInput = new ConnectApi.FulfillmentOrderInputRepresentation();
            fulfillmentOrderInput.orderSummaryId = orderSummaryId;

            List<OrderDeliveryGroupSummary> currentOrderDeliveryGroupSummaryList = orderSummaryIdToOrderDeliveryGroupSummaryList.get(orderSummaryId);
            
            for (OrderDeliveryGroupSummary orderDeliveryGroupSummary: currentOrderDeliveryGroupSummaryList) {
                fulfillmentOrderInput.orderDeliveryGroupSummaryId = orderDeliveryGroupSummary.Id;
    
                List<ConnectApi.FulfillmentGroupInputRepresentation> fulfillmentGroups = new List<ConnectApi.FulfillmentGroupInputRepresentation>();
                ConnectApi.FulfillmentGroupInputRepresentation fulfillmentGroup = new ConnectApi.FulfillmentGroupInputRepresentation();
                fulfillmentGroup.fulfilledFromLocationId = locationId;
                fulfillmentGroup.fulfillmentType = fulfillmentType;
                fulfillmentGroup.referenceId = CreateFulfillmentOrderInput.orderSummaryId;
    
                List<ConnectApi.OrderItemSummaryInputRepresentation> orderItemSummaryInputList = new List<ConnectApi.OrderItemSummaryInputRepresentation>();
                List<OrderItemSummary> orderItemSummaryList = orderDeliveryGroupSummaryIdToOrderItemSummaryList.get(orderDeliveryGroupSummary.Id);
    
                for(OrderItemSummary orderItemSummary : orderItemSummaryList) {
                    ConnectApi.OrderItemSummaryInputRepresentation orderItemSummaryInput = new ConnectApi.OrderItemSummaryInputRepresentation();
                    orderItemSummaryInput.orderItemSummaryId = orderItemSummary.Id;
                    orderItemSummaryInput.quantity = orderItemSummary.Quantity;
                    orderItemSummaryInputList.add(orderItemSummaryInput);
                }
    
                fulfillmentGroup.orderItemSummaries = orderItemSummaryInputList;
                fulfillmentGroups.add(fulfillmentGroup);
                fulfillmentOrderInput.fulfillmentGroups = fulfillmentGroups;
            }

            multipleFulfillmentOrderInput.fulfillmentOrders.add(fulfillmentOrderInput);
        }

        ConnectApi.MultipleFulfillmentOrderOutputRepresentation output = ConnectApi.FulfillmentOrder.createMultipleFulfillmentOrder(multipleFulfillmentOrderInput);
        super.insertFailedResults(output);
        return output;
    }

    /**
    * @description Create Invoices for multiple FulfillmentOrders 
    * @param fulfillmentOrderIds The list of FulfillmentOrder Ids
    * @return Ids of the created Invoices
    */
    public ConnectApi.MultipleFulfillmentOrderInvoicesOutputRepresentation createMultipleInvoices(List<String> fulfillmentOrderIds) {
        ConnectApi.MultipleFulfillmentOrderInvoicesInputRepresentation input = new ConnectApi.MultipleFulfillmentOrderInvoicesInputRepresentation();
        input.fulfillmentOrderIds = fulfillmentOrderIds;

        ConnectApi.MultipleFulfillmentOrderInvoicesOutputRepresentation output = ConnectApi.FulfillmentOrder.createMultipleInvoices(input);
        super.insertFailedResults(output);
        return output;
    }

    /**
    * @description Returns Ids of OrderSummary list from request
    * @param createFulfillmentOrderList List of input contains
    *   LocationId, OrderSummaryId, FulfillmentType
    * @return OrderSummary Id list
    */
    private Set<Id> getOrderSummaryIdList(List<CreateFulfillmentOrderInput> createFulfillmentOrderList) {
        Set<Id> orderSummaryIdList = new Set<Id>();

        for (CreateFulfillmentOrderInput createFulfillmentOrderInput : createFulfillmentOrderList) {
            orderSummaryIdList.add(CreateFulfillmentOrderInput.orderSummaryId);
        }

        return orderSummaryIdList;
    }

    /**
    * @description Gets OrderSummaryId to OrderDeliveryGroupSummary map
    * @param orderDeliveryGroupSummaryList List of OrderDeliveryGroupSummary records
    * @return Map of OrderSummaryId to OrderDeliveryGroupSummary
    */
    private Map<String, List<OrderDeliveryGroupSummary>> getOrderDeliveryGroupSummaryMap(List<OrderDeliveryGroupSummary> orderDeliveryGroupSummaryList) {
        Map<String, List<OrderDeliveryGroupSummary>> orderSummaryIdToOrderDeliveryGroupSummaryList = new Map<String, List<OrderDeliveryGroupSummary>>();

        // map OrderSummary.Id to OrderDeliveryGroupSummary list
        for (OrderDeliveryGroupSummary orderDeliveryGroupSummary : orderDeliveryGroupSummaryList) {
            List<OrderDeliveryGroupSummary> existingOrderDeliveryGroupSummaryList =  orderSummaryIdToOrderDeliveryGroupSummaryList.get(orderDeliveryGroupSummary.OrderSummaryId);

            if (existingOrderDeliveryGroupSummaryList == null) {
                orderSummaryIdToOrderDeliveryGroupSummaryList.put(orderDeliveryGroupSummary.OrderSummaryId, new List<OrderDeliveryGroupSummary>{ orderDeliveryGroupSummary });
            }
            else {
                existingOrderDeliveryGroupSummaryList.add(orderDeliveryGroupSummary);
            }
        }

        return orderSummaryIdToOrderDeliveryGroupSummaryList;
    }

    /**
    * @description Gets OrderDeliveryGroupSummaryId to list of OrderItemSummary map
    * @param orderDeliveryGroupSummaryList List of OrderDeliveryGroupSummary records
    * @return Map of  OrderDeliveryGroupSummaryId to list of OrderItemSummary
    */
    private Map<String, List<OrderItemSummary>> getOrderItemSummaryMap(List<OrderDeliveryGroupSummary> orderDeliveryGroupSummaryList) {
        Map<String, List<OrderItemSummary>> orderDeliveryGroupSummaryIdToOrderItemSummaryList = new Map<String, List<OrderItemSummary>>();

        List<OrderItemSummary> orderItemSummaryList = [SELECT Quantity, OrderDeliveryGroupSummaryId FROM OrderItemSummary 
                                                    WHERE OrderDeliveryGroupSummaryId =: orderDeliveryGroupSummaryList 
                                                    WITH SECURITY_ENFORCED];

        for (OrderItemSummary orderItemSummary : orderItemSummaryList) {
            List<OrderItemSummary> existingOrderItemSummaryList = orderDeliveryGroupSummaryIdToOrderItemSummaryList.get(orderItemSummary.OrderDeliveryGroupSummaryId);

            if (existingOrderItemSummaryList == null) {
                orderDeliveryGroupSummaryIdToOrderItemSummaryList.put(orderItemSummary.OrderDeliveryGroupSummaryId, new List<OrderItemSummary>{ orderItemSummary });
            }
            else {
                existingOrderItemSummaryList.add(orderItemSummary);
            }
        }

        return orderDeliveryGroupSummaryIdToOrderItemSummaryList;
    }

    /**
    * @description Model for createMultipleFulfillmentOrder action
    */
    public class CreateFulfillmentOrderInput {
        public String locationId;
        public String orderSummaryId;
        public String fulfillmentType;
    }
}