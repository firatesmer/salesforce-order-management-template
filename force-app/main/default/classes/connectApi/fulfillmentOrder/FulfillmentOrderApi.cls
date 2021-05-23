/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description FulfillmentOrder Api class
*/
public with sharing class FulfillmentOrderApi extends BaseApi {
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
    * @param createFulfillmentOrder CreateFulfillmentOrder model
    * @return FulfillmentOrder output
    */
    public ConnectApi.FulfillmentOrderOutputRepresentation createFulfillmentOrders(CreateFulfillmentOrder createFulfillmentOrder) {
        String orderSummaryId = createFulfillmentOrder.orderSummaryId;
        String locationId = createFulfillmentOrder.locationId;
        String fulfillmentType = createFulfillmentOrder.fulfillmentType;

        ConnectApi.FulfillmentOrderInputRepresentation fulfillmentOrderInput = new ConnectApi.FulfillmentOrderInputRepresentation();
        fulfillmentOrderInput.orderSummaryId = orderSummaryId;
        
        List<OrderDeliveryGroupSummary> orderDeliveryGroupSummaryList = [SELECT Id FROM OrderDeliveryGroupSummary WHERE OrderSummaryId =: orderSummaryId WITH SECURITY_ENFORCED];
        Map<String, List<OrderItemSummary>> orderDeliveryGroupSummaryIdToOrderItemSummaryList = getOrderItemSummaryMap(orderDeliveryGroupSummaryList);

        for (OrderDeliveryGroupSummary orderDeliveryGroupSummary: orderDeliveryGroupSummaryList) {
            fulfillmentOrderInput.orderDeliveryGroupSummaryId = orderDeliveryGroupSummary.Id;

            List<ConnectApi.FulfillmentGroupInputRepresentation> fulfillmentGroups = new List<ConnectApi.FulfillmentGroupInputRepresentation>();
            ConnectApi.FulfillmentGroupInputRepresentation fulfillmentGroup = new ConnectApi.FulfillmentGroupInputRepresentation();
            fulfillmentGroup.fulfilledFromLocationId = locationId;
            fulfillmentGroup.fulfillmentType = fulfillmentType;

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
    * @return CreateInvoice output
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
    * @param lineItemIdToCancelQuantity Map<FulfillmentOrderLineItem.Id, FulfillmentOrderLineItem.Quantity/QuantityCancelled
    * @return CancelLineItems output
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
    * @param createFulfillmentOrderList CreateFulfillmentOrder model list
    * @return MultipleFulfillmentOrder output
    */
    public ConnectApi.MultipleFulfillmentOrderOutputRepresentation createMultipleFulfillmentOrder(List<CreateFulfillmentOrder> createFulfillmentOrderList) {
        ConnectApi.MultipleFulfillmentOrderInputRepresentation multipleFulfillmentOrderInput = new ConnectApi.MultipleFulfillmentOrderInputRepresentation();
        multipleFulfillmentOrderInput.fulfillmentOrders = new List<ConnectApi.FulfillmentOrderInputRepresentation>();

        // prevent query in loop
        Set<Id> orderSummaryIdList = getOrderSummaryIdList(createFulfillmentOrderList);
        List<OrderDeliveryGroupSummary> orderDeliveryGroupSummaryList = [SELECT OrderSummaryId FROM OrderDeliveryGroupSummary 
                                                                        WHERE OrderSummaryId IN: orderSummaryIdList 
                                                                        WITH SECURITY_ENFORCED];
        Map<String, List<OrderDeliveryGroupSummary>> orderSummaryIdToOrderDeliveryGroupSummaryList = getOrderDeliveryGroupSummaryMap(orderDeliveryGroupSummaryList);
        Map<String, List<OrderItemSummary>> orderDeliveryGroupSummaryIdToOrderItemSummaryList = getOrderItemSummaryMap(orderDeliveryGroupSummaryList);

        for (CreateFulfillmentOrder createFulfillmentOrder : createFulfillmentOrderList) {
            String orderSummaryId = createFulfillmentOrder.orderSummaryId;
            String locationId = createFulfillmentOrder.locationId;
            String fulfillmentType = createFulfillmentOrder.fulfillmentType;

            ConnectApi.FulfillmentOrderInputRepresentation fulfillmentOrderInput = new ConnectApi.FulfillmentOrderInputRepresentation();
            fulfillmentOrderInput.orderSummaryId = orderSummaryId;

            List<OrderDeliveryGroupSummary> currentOrderDeliveryGroupSummaryList = orderSummaryIdToOrderDeliveryGroupSummaryList.get(orderSummaryId);
            
            for (OrderDeliveryGroupSummary orderDeliveryGroupSummary: currentOrderDeliveryGroupSummaryList) {
                fulfillmentOrderInput.orderDeliveryGroupSummaryId = orderDeliveryGroupSummary.Id;
    
                List<ConnectApi.FulfillmentGroupInputRepresentation> fulfillmentGroups = new List<ConnectApi.FulfillmentGroupInputRepresentation>();
                ConnectApi.FulfillmentGroupInputRepresentation fulfillmentGroup = new ConnectApi.FulfillmentGroupInputRepresentation();
                fulfillmentGroup.fulfilledFromLocationId = locationId;
                fulfillmentGroup.fulfillmentType = fulfillmentType;
                fulfillmentGroup.referenceId = createFulfillmentOrder.orderSummaryId;
    
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
    * @description Model for create FulfillmentOrder action
    */
    public class CreateFulfillmentOrder {
        public String locationId;
        public String orderSummaryId;
        public String fulfillmentType;
    }

    /**
    * @description Returns Ids of OrderSummary list from request
    * @param createFulfillmentOrderList Request list
    * @return OrderSummary Id list
    */
    private Set<Id> getOrderSummaryIdList(List<CreateFulfillmentOrder> createFulfillmentOrderList) {
        Set<Id> orderSummaryIdList = new Set<Id>();

        for (CreateFulfillmentOrder createFulfillmentOrder : createFulfillmentOrderList) {
            orderSummaryIdList.add(createFulfillmentOrder.orderSummaryId);
        }

        return orderSummaryIdList;
    }

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

    private Map<String, List<OrderItemSummary>> getOrderItemSummaryMap(List<OrderDeliveryGroupSummary> orderDeliveryGroupSummaryList) {
        Map<String, List<OrderItemSummary>> orderDeliveryGroupSummaryIdToOrderItemSummaryList = new Map<String, List<OrderItemSummary>>();

        Set<String> orderDeliveryGroupSummaryIdList = ObjectUtils.getIdList(orderDeliveryGroupSummaryList);

        List<OrderItemSummary> orderItemSummaryList = [SELECT Quantity, OrderDeliveryGroupSummaryId FROM OrderItemSummary 
                                                    WHERE OrderDeliveryGroupSummaryId IN: orderDeliveryGroupSummaryIdList 
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
}