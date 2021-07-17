/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 14/07/2021
* @description ReturnOrder Api test class
*/
@isTest
private class ReturnOrderApiTest {
    /**
    * @description Test method of ReturnOrderApi.createReturnOrder
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldCreateReturnOrder() {
        String orderId = TestDataFactory.createOrder();

        OrderSummary orderSummary = TestDataFactory.createOrderSummary(orderId);

        Schema.Location location = [SELECT Id FROM Location WHERE Name =: Constants.WAREHOUSE LIMIT 1];

        FulfillmentOrderApi fulfillmentOrderApi = new FulfillmentOrderApi();

        ConnectApi.FulfillmentOrderOutputRepresentation fulfillmentOrderOutput = fulfillmentOrderApi.createFulfillmentOrders(location.Id, orderSummary.Id, FulfillmentOrderType.WAREHOUSE);
        String fulfillmentOrderId = fulfillmentOrderOutput.fulfillmentOrderIds[0];

        FulfillmentOrder fulfillmentOrder = [SELECT Id FROM FulfillmentOrder WHERE Id =: fulfillmentOrderId];
        fulfillmentOrder.Status = FulfillmentOrderStatus.FULFILLED.enumValue;
        DatabaseUtils.updateRecords(new List<FulfillmentOrder>{ fulfillmentOrder }, true);

        List<OrderItemSummary> orderItemSummaries = [
            SELECT Type, Quantity, QuantityAvailableToReturn
            FROM OrderItemSummary 
            WHERE OrderSummaryId =: orderSummary.Id
            AND Type =: OrderItemType.ORDER_PRODUCT.enumValue];

        Boolean areOrderItemsReturnable = false;

        for (OrderItemSummary orderItemSummary : orderItemSummaries) {
            areOrderItemsReturnable = OrderSummaryService.isOrderItemReturnable(orderItemSummary);
            if (!areOrderItemsReturnable) {
                break;
            }
        }

        System.assert(areOrderItemsReturnable, 'Order item is not returnable');

        if (areOrderItemsReturnable) {
            List<ConnectApi.ReturnOrderLineItemInputRepresentation> returnOrderLineItemInputList = new List<ConnectApi.ReturnOrderLineItemInputRepresentation>();
            for (OrderItemSummary orderItemSummary : orderItemSummaries) {
                ConnectApi.ReturnOrderLineItemInputRepresentation returnOrderLineItemInput = new ConnectApi.ReturnOrderLineItemInputRepresentation();
                returnOrderLineItemInput.canReduceShipping = true;
                returnOrderLineItemInput.orderItemSummaryId = orderItemSummary.Id;
                returnOrderLineItemInput.quantityExpected = 1;
                returnOrderLineItemInput.quantityReceived = 1;
                returnOrderLineItemInput.reasonForReturn = ReturnOrderLineItemReturnReason.WRONG_ITEM.enumValue;
                returnOrderLineItemInputList.add(returnOrderLineItemInput);
            }
            
            Test.startTest();
            ConnectApi.ReturnOrderOutputRepresentation output = new ReturnOrderApi().createReturnOrder(orderSummary.Id, ReturnOrderStatus.DRAFT, returnOrderLineItemInputList);
            Test.stopTest();

            List<ReturnOrder> returnOrders = [SELECT Id FROM ReturnOrder WHERE OrderSummaryId =: orderSummary.Id];

            System.assert(output.success, 'Create return order action failed');
            System.assert(!returnOrders.isEmpty(), 'No ReturnOrder records found');
        }
    }
}