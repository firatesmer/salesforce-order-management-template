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
    @SuppressWarnings('PMD.OperationWithLimitsInLoop')
    public ConnectApi.FulfillmentOrderOutputRepresentation createFulfillmentOrders(CreateFulfillmentOrder createFulfillmentOrder) {
        String orderSummaryId = createFulfillmentOrder.orderSummaryId;
        String locationId = createFulfillmentOrder.locationId;
        String fulfillmentType = createFulfillmentOrder.fulfillmentType;

        ConnectApi.FulfillmentOrderInputRepresentation fulfillmentOrderInput = new ConnectApi.FulfillmentOrderInputRepresentation();
        fulfillmentOrderInput.orderSummaryId = orderSummaryId;
        
        List<OrderDeliveryGroupSummary> orderDeliveryGroupSummaryList = [SELECT Id FROM OrderDeliveryGroupSummary WHERE OrderSummaryId =: orderSummaryId WITH SECURITY_ENFORCED];

        for (OrderDeliveryGroupSummary orderDeliveryGroupSummary: orderDeliveryGroupSummaryList) {
            fulfillmentOrderInput.orderDeliveryGroupSummaryId = orderDeliveryGroupSummary.Id;

            List<ConnectApi.FulfillmentGroupInputRepresentation> fulfillmentGroups = new List<ConnectApi.FulfillmentGroupInputRepresentation>();
            ConnectApi.FulfillmentGroupInputRepresentation fulfillmentGroup = new ConnectApi.FulfillmentGroupInputRepresentation();
            fulfillmentGroup.fulfilledFromLocationId = locationId;
            fulfillmentGroup.fulfillmentType = fulfillmentType;

            List<ConnectApi.OrderItemSummaryInputRepresentation> orderItemSummaryInputList = new List<ConnectApi.OrderItemSummaryInputRepresentation>();
            List<OrderItemSummary> orderItemSummaryList = [SELECT Quantity FROM OrderItemSummary 
                WHERE OrderSummaryId =: orderSummaryId AND OrderDeliveryGroupSummaryId =: orderDeliveryGroupSummary.Id WITH SECURITY_ENFORCED];

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
    @SuppressWarnings('PMD.OperationWithLimitsInLoop')
    public ConnectApi.MultipleFulfillmentOrderOutputRepresentation createMultipleFulfillmentOrder(List<CreateFulfillmentOrder> createFulfillmentOrderList) {
        ConnectApi.MultipleFulfillmentOrderInputRepresentation multipleFulfillmentOrderInput = new ConnectApi.MultipleFulfillmentOrderInputRepresentation();
        multipleFulfillmentOrderInput.fulfillmentOrders = new List<ConnectApi.FulfillmentOrderInputRepresentation>();

        for (CreateFulfillmentOrder createFulfillmentOrder : createFulfillmentOrderList) {
            String orderSummaryId = createFulfillmentOrder.orderSummaryId;
            String locationId = createFulfillmentOrder.locationId;
            String fulfillmentType = createFulfillmentOrder.fulfillmentType;

            ConnectApi.FulfillmentOrderInputRepresentation fulfillmentOrderInput = new ConnectApi.FulfillmentOrderInputRepresentation();
            fulfillmentOrderInput.orderSummaryId = orderSummaryId;
            
            List<OrderDeliveryGroupSummary> orderDeliveryGroupSummaryList = [SELECT Id FROM OrderDeliveryGroupSummary 
                WHERE OrderSummaryId =: orderSummaryId WITH SECURITY_ENFORCED];
    
            for (OrderDeliveryGroupSummary orderDeliveryGroupSummary: orderDeliveryGroupSummaryList) {
                fulfillmentOrderInput.orderDeliveryGroupSummaryId = orderDeliveryGroupSummary.Id;
    
                List<ConnectApi.FulfillmentGroupInputRepresentation> fulfillmentGroups = new List<ConnectApi.FulfillmentGroupInputRepresentation>();
                ConnectApi.FulfillmentGroupInputRepresentation fulfillmentGroup = new ConnectApi.FulfillmentGroupInputRepresentation();
                fulfillmentGroup.fulfilledFromLocationId = locationId;
                fulfillmentGroup.fulfillmentType = fulfillmentType;
                fulfillmentGroup.referenceId = createFulfillmentOrder.orderSummaryId;
    
                List<ConnectApi.OrderItemSummaryInputRepresentation> orderItemSummaryInputList = new List<ConnectApi.OrderItemSummaryInputRepresentation>();
                List<OrderItemSummary> orderItemSummaryList = [SELECT Quantity FROM OrderItemSummary 
                    WHERE OrderSummaryId =: orderSummaryId AND OrderDeliveryGroupSummaryId =: orderDeliveryGroupSummary.Id WITH SECURITY_ENFORCED];
    
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

        System.debug('multipleFulfillmentOrderInput: ' + multipleFulfillmentOrderInput);

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
}