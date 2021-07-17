/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description FulfillmentOrder Api test class
*/
@isTest
private class FulfillmentOrderApiTest {
    /**
    * @description Test method of FulfillmentOrderApi.createFulfillmentOrders
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldCreateFulfillmentOrders() {
        String orderId = TestDataFactory.createOrder();

        OrderSummary orderSummary = TestDataFactory.createOrderSummary(orderId);

        Schema.Location location = [SELECT Id FROM Location WHERE Name =: Constants.WAREHOUSE LIMIT 1];

        Test.startTest();
        ConnectApi.FulfillmentOrderOutputRepresentation output = new FulfillmentOrderApi().createFulfillmentOrders(orderSummary.Id, location.Id, FulfillmentOrderType.WAREHOUSE);
        Test.stopTest();

        List<FulfillmentOrder> fulfillmentOrders = [SELECT Id FROM FulfillmentOrder WHERE OrderSummaryId =: orderSummary.Id];

        System.assert(output.success, 'Create fulfillment orders action failed');
        System.assert(!fulfillmentOrders.isEmpty(), 'No fulfillment orders found');
    }

    /**
    * @description Test method of FulfillmentOrderApi.createInvoice
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldCreateInvoice() {
        String orderId = TestDataFactory.createOrder();

        FulfillmentOrderApi api = new FulfillmentOrderApi();

        OrderSummary orderSummary = TestDataFactory.createOrderSummary(orderId);

        Schema.Location location = [SELECT Id FROM Location WHERE Name =: Constants.WAREHOUSE LIMIT 1];

        api.createFulfillmentOrders(orderSummary.Id, location.Id, FulfillmentOrderType.WAREHOUSE);

        FulfillmentOrder fulfillmentOrder = [SELECT Id FROM FulfillmentOrder WHERE OrderSummaryID =: orderSummary.Id];

        Test.startTest();
        ConnectApi.FulfillmentOrderInvoiceOutputRepresentation output = api.createInvoice(fulfillmentOrder.Id);
        Test.stopTest();

        fulfillmentOrder = [SELECT InvoiceId FROM FulfillmentOrder WHERE Id =: fulfillmentOrder.Id];

        System.assert(output.success, 'Create invoice action failed');
        System.assert(fulfillmentOrder.InvoiceID != null, 'No invoices found');
    }

    /**
    * @description Test method of FulfillmentOrderApi.cancelFulfillmentOrderLineItems
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldCancelFulfillmentOrderLineItems() {
        String orderId = TestDataFactory.createOrder();

        OrderSummary orderSummary = TestDataFactory.createOrderSummary(orderId);

        Schema.Location location = [SELECT Id FROM Location WHERE Name =: Constants.WAREHOUSE LIMIT 1];

        FulfillmentOrderApi api = new FulfillmentOrderApi();

        api.createFulfillmentOrders(orderSummary.Id, location.Id, FulfillmentOrderType.WAREHOUSE);

        FulfillmentOrder fulfillmentOrder = [SELECT Id FROM FulfillmentOrder WHERE OrderSummaryID =: orderSummary.Id];

        List<FulfillmentOrderLineItem> fulfillmentOrderLineItems = [SELECT Quantity FROM FulfillmentOrderLineItem WHERE FulfillmentOrderID =: fulfillmentOrder.Id];

        Map<String, Decimal> lineItemIdToCancelQuantity = new Map<String, Decimal>();
        for (FulfillmentOrderLineItem fulfillmentOrderLineItem : fulfillmentOrderLineItems) {
            lineItemIdToCancelQuantity.put(fulfillmentOrderLineItem.Id, fulfillmentOrderLineItem.Quantity);
        }

        Test.startTest();
        ConnectApi.FulfillmentOrderCancelLineItemsOutputRepresentation output = api.cancelFulfillmentOrderLineItems(fulfillmentOrder.Id, lineItemIdToCancelQuantity);
        Test.stopTest();

        fulfillmentOrderLineItems = [SELECT Quantity FROM FulfillmentOrderLineItem WHERE FulfillmentOrderID =: fulfillmentOrder.Id];

        for (FulfillmentOrderLineItem fulfillmentOrderLineItem : fulfillmentOrderLineItems) {
            System.assert(fulfillmentOrderLineItem.Quantity == 0, String.format('Fulfillment order line item quantity is {0}', new List<String>{ String.valueOf(fulfillmentOrderLineItem.Quantity) }));
        }

        System.assert(output.success, 'Cancel fulfillment order line items action failed');
    }

    /**
    * @description Test method of FulfillmentOrderApi.createMultipleFulfillmentOrder
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldCreateMultipleFulfillmentOrder() {
        String order1Id = TestDataFactory.createOrder();
        String order2Id = TestDataFactory.createOrder();

        OrderSummary orderSummary1 = TestDataFactory.createOrderSummary(order1Id);
        OrderSummary orderSummary2 = TestDataFactory.createOrderSummary(order2Id);

        List<OrderSummary> orderSummaries = new List<OrderSummary>
        {
            orderSummary1, orderSummary2
        };

        Schema.Location location = [SELECT Id FROM Location WHERE Name =: Constants.WAREHOUSE LIMIT 1];

        FulfillmentOrderApi api = new FulfillmentOrderApi();

        // createFulfillmentOrders request
        List<FulfillmentOrderApi.CreateFulfillmentOrderInput> createFulfillmentOrderList = new List<FulfillmentOrderApi.CreateFulfillmentOrderInput>();
        for (OrderSummary orderSummary : orderSummaries) {
            FulfillmentOrderApi.CreateFulfillmentOrderInput createFulfillmentOrderInput = FulfillmentOrderService.buildCreateFulfillmentOrderInput(orderSummary.Id, location.Id, Constants.WAREHOUSE);
            createFulfillmentOrderList.add(CreateFulfillmentOrderInput);
        }

        Test.startTest();
        ConnectApi.MultipleFulfillmentOrderOutputRepresentation output = api.createMultipleFulfillmentOrder(createFulfillmentOrderList);
        Test.stopTest();

        List<FulfillmentOrder> fulfillmentOrders = [SELECT Id FROM FulfillmentOrder 
            WHERE OrderSummaryId =: orderSummaries];

        System.assert(output.success, 'Create fulfillment orders action failed');
        System.assert(fulfillmentOrders.size() > 1, 'There should be multiple FulfillmentOrder records');
    }

    /**
    * @description Test method of FulfillmentOrderApi.createMultipleFulfillmentOrder
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldCreateMultipleInvoices() {
        String order1Id = TestDataFactory.createOrder();
        String order2Id = TestDataFactory.createOrder();

        OrderSummary orderSummary1 = TestDataFactory.createOrderSummary(order1Id);
        OrderSummary orderSummary2 = TestDataFactory.createOrderSummary(order2Id);
        
        List<OrderSummary> orderSummaries = new List<OrderSummary>
        {
            orderSummary1, orderSummary2
        };

        Schema.Location location = [SELECT Id FROM Location WHERE Name =: Constants.WAREHOUSE LIMIT 1];

        FulfillmentOrderApi api = new FulfillmentOrderApi();

        // createFulfillmentOrders request
        List<FulfillmentOrderApi.CreateFulfillmentOrderInput> createFulfillmentOrderList = new List<FulfillmentOrderApi.CreateFulfillmentOrderInput>();
        for (OrderSummary orderSummary : orderSummaries) {
            FulfillmentOrderApi.CreateFulfillmentOrderInput createFulfillmentOrderInput = FulfillmentOrderService.buildCreateFulfillmentOrderInput(orderSummary.Id, location.Id, Constants.WAREHOUSE);
            createFulfillmentOrderList.add(CreateFulfillmentOrderInput);
        }

        ConnectApi.MultipleFulfillmentOrderOutputRepresentation createMultipleFulfillmentOrderOutput = api.createMultipleFulfillmentOrder(createFulfillmentOrderList);

        List<String> fulfillmentOrderIds = new List<String>();

        for (ConnectApi.FulfillmentGroupOutputRepresentation fulfillmentGroupOutput : createMultipleFulfillmentOrderOutput.fulfillmentOrders) {
            fulfillmentOrderIds.add(fulfillmentGroupOutput.fulfillmentOrderId);
        }

        Test.startTest();
        ConnectApi.MultipleFulfillmentOrderInvoicesOutputRepresentation output = api.createMultipleInvoices(fulfillmentOrderIds);
        Test.stopTest();

        List<FulfillmentOrder> fulfillmentOrders = [SELECT InvoiceId FROM FulfillmentOrder WHERE Id IN: fulfillmentOrderIds];

        System.assert(output.success, 'Create multiple invoices action failed');
        
        for (FulfillmentOrder fulfillmentOrder : fulfillmentOrders) {
            System.assert(String.isNotEmpty(fulfillmentOrder.InvoiceId), 'No invoice found');
        }
    }
}