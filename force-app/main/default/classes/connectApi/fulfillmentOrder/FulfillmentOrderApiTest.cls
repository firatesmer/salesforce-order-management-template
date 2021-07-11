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
    @SuppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @IsTest(SeeAllData=true)
    static void shouldCreateFulfillmentOrders() {
        String orderId = TestDataFactory.createOrder();

        /**
        * In most cases we will have a flow that creates 
        * OrderSummary automatically once the Order is 
        * activated so we will check if the OrderSummary 
        * is already created behind the scenes to prevent 
        * test fail but in that case code will not be covered
        */
        List<OrderSummary> orderSummaries = [SELECT TaxLocaleType FROM OrderSummary WHERE OriginalOrderId =: orderId];
        OrderSummary orderSummary;

        if(orderSummaries.isEmpty()) {
            TestDataFactory.createOrderSummary(orderId);
            orderSummary = [SELECT Id FROM OrderSummary WHERE OriginalOrderId =: orderId];
        }
        else {
            orderSummary = orderSummaries[0];
        }

        Schema.Location location = [SELECT Id FROM Location WHERE Name =: Constants.WAREHOUSE LIMIT 1];

        // createFulfillmentOrders request
        FulfillmentOrderApi.CreateFulfillmentOrder createFulfillmentOrder = FulfillmentOrderService.buildCreateFulfillmentOrderRequest(orderSummary.Id, location.Id, Constants.WAREHOUSE);

        Test.startTest();
        ConnectApi.FulfillmentOrderOutputRepresentation output = new FulfillmentOrderApi().createFulfillmentOrders(createFulfillmentOrder);
        Test.stopTest();

        List<FulfillmentOrder> fulfillmentOrders = [SELECT Id FROM FulfillmentOrder WHERE OrderSummaryId =: orderSummary.Id];

        System.assert(output.success, 'Create fulfillment orders action failed');
        System.assert(!fulfillmentOrders.isEmpty(), 'No fulfillment orders found');
    }

    /**
    * @description Test method of FulfillmentOrderApi.createInvoice
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @SuppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @IsTest(SeeAllData=true)
    static void shouldCreateInvoice() {
        String orderId = TestDataFactory.createOrder();

        FulfillmentOrderApi api = new FulfillmentOrderApi();

        /**
        * In most cases we will have a flow that creates 
        * OrderSummary automatically once the Order is 
        * activated so we will check if the OrderSummary 
        * is already created behind the scenes to prevent 
        * test fail but in that case code will not be covered
        */
        List<OrderSummary> orderSummaries = [SELECT TaxLocaleType FROM OrderSummary WHERE OriginalOrderId =: orderId];
        OrderSummary orderSummary;

        if(orderSummaries.isEmpty()) {
            TestDataFactory.createOrderSummary(orderId);
            orderSummary = [SELECT Id FROM OrderSummary WHERE OriginalOrderId =: orderId];
        }
        else {
            orderSummary = orderSummaries[0];
        }

        Schema.Location location = [SELECT Id FROM Location WHERE Name =: Constants.WAREHOUSE LIMIT 1];

        // createFulfillmentOrders request
        FulfillmentOrderApi.CreateFulfillmentOrder createFulfillmentOrder = FulfillmentOrderService.buildCreateFulfillmentOrderRequest(orderSummary.Id, location.Id, Constants.WAREHOUSE);
        api.createFulfillmentOrders(createFulfillmentOrder);

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
    @SuppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @IsTest(SeeAllData=true)
    static void shouldCancelFulfillmentOrderLineItems() {
        String orderId = TestDataFactory.createOrder();

        /**
        * In most cases we will have a flow that creates 
        * OrderSummary automatically once the Order is 
        * activated so we will check if the OrderSummary 
        * is already created behind the scenes to prevent 
        * test fail but in that case code will not be covered
        */
        List<OrderSummary> orderSummaries = [SELECT TaxLocaleType FROM OrderSummary WHERE OriginalOrderId =: orderId];
        OrderSummary orderSummary;

        if(orderSummaries.isEmpty()) {
            TestDataFactory.createOrderSummary(orderId);
            orderSummary = [SELECT Id FROM OrderSummary WHERE OriginalOrderId =: orderId];
        }
        else {
            orderSummary = orderSummaries[0];
        }

        Schema.Location location = [SELECT Id FROM Location WHERE Name =: Constants.WAREHOUSE LIMIT 1];

        FulfillmentOrderApi api = new FulfillmentOrderApi();

        // createFulfillmentOrders request
        FulfillmentOrderApi.CreateFulfillmentOrder createFulfillmentOrder = FulfillmentOrderService.buildCreateFulfillmentOrderRequest(orderSummary.Id, location.Id, Constants.WAREHOUSE);
        api.createFulfillmentOrders(createFulfillmentOrder);

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
    @SuppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @IsTest(SeeAllData=true)
    static void shouldCreateMultipleFulfillmentOrder() {
        String order1Id = TestDataFactory.createOrder();
        String order2Id = TestDataFactory.createOrder();
        List<String> orderIds = new List<String>{ order1Id, order2Id };
        List<String> orderSummaryIds = new List<String>{ };

        /**
        * In most cases we will have a flow that creates 
        * OrderSummary automatically once the Order is 
        * activated so we will check if the OrderSummary 
        * is already created behind the scenes to prevent 
        * test fail but in that case code will not be covered
        */
        List<OrderSummary> orderSummaries = [SELECT Id FROM OrderSummary WHERE OriginalOrderId IN: orderIds];

        if(orderSummaries.isEmpty()) {
            TestDataFactory.createOrderSummary(order1Id);
            TestDataFactory.createOrderSummary(order2Id);
            orderSummaries = [SELECT Id FROM OrderSummary WHERE OriginalOrderId IN: orderIds];
        }

        Schema.Location location = [SELECT Id FROM Location WHERE Name =: Constants.WAREHOUSE LIMIT 1];

        FulfillmentOrderApi api = new FulfillmentOrderApi();

        // createFulfillmentOrders request
        List<FulfillmentOrderApi.CreateFulfillmentOrder> createFulfillmentOrderList = new List<FulfillmentOrderApi.CreateFulfillmentOrder>();
        for (OrderSummary orderSummary : orderSummaries) {
            orderSummaryIds.add(orderSummary.Id);
            FulfillmentOrderApi.CreateFulfillmentOrder createFulfillmentOrder = FulfillmentOrderService.buildCreateFulfillmentOrderRequest(orderSummary.Id, location.Id, Constants.WAREHOUSE);
            createFulfillmentOrderList.add(createFulfillmentOrder);
        }

        Test.startTest();
        ConnectApi.MultipleFulfillmentOrderOutputRepresentation output = api.createMultipleFulfillmentOrder(createFulfillmentOrderList);
        Test.stopTest();

        List<FulfillmentOrder> fulfillmentOrders = [SELECT Id FROM FulfillmentOrder 
            WHERE OrderSummaryId IN: orderSummaryIds];

        System.assert(output.success, 'Create fulfillment orders action failed');
        System.assert(fulfillmentOrders.size() > 1, 'There should be multiple FulfillmentOrder records');
    }

    /**
    * @description Test method of FulfillmentOrderApi.createMultipleFulfillmentOrder
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @SuppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @IsTest(SeeAllData=true)
    static void shouldCreateMultipleInvoices() {
        String order1Id = TestDataFactory.createOrder();
        String order2Id = TestDataFactory.createOrder();
        List<String> orderIds = new List<String>{ order1Id, order2Id };
        List<String> orderSummaryIds = new List<String>{ };

        /**
        * In most cases we will have a flow that creates 
        * OrderSummary automatically once the Order is 
        * activated so we will check if the OrderSummary 
        * is already created behind the scenes to prevent 
        * test fail but in that case code will not be covered
        */
        List<OrderSummary> orderSummaries = [SELECT Id FROM OrderSummary WHERE OriginalOrderId IN: orderIds];

        if(orderSummaries.isEmpty()) {
            TestDataFactory.createOrderSummary(order1Id);
            TestDataFactory.createOrderSummary(order2Id);
            orderSummaries = [SELECT Id FROM OrderSummary WHERE OriginalOrderId IN: orderIds];
        }

        Schema.Location location = [SELECT Id FROM Location WHERE Name =: Constants.WAREHOUSE LIMIT 1];

        FulfillmentOrderApi api = new FulfillmentOrderApi();

        // createFulfillmentOrders request
        List<FulfillmentOrderApi.CreateFulfillmentOrder> createFulfillmentOrderList = new List<FulfillmentOrderApi.CreateFulfillmentOrder>();
        for (OrderSummary orderSummary : orderSummaries) {
            orderSummaryIds.add(orderSummary.Id);
            FulfillmentOrderApi.CreateFulfillmentOrder createFulfillmentOrder = FulfillmentOrderService.buildCreateFulfillmentOrderRequest(orderSummary.Id, location.Id, Constants.WAREHOUSE);
            createFulfillmentOrderList.add(createFulfillmentOrder);
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