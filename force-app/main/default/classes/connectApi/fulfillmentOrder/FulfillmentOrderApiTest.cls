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
        String orderId = createOrder();

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
            createOrderSummary(orderId);
            orderSummary = [SELECT Id FROM OrderSummary WHERE OriginalOrderId =: orderId];
        }
        else {
            orderSummary = orderSummaries[0];
        }

        Schema.Location location = [SELECT Id FROM Location WHERE Name =: Constants.WAREHOUSE LIMIT 1];

        // createFulfillmentOrders request
        FulfillmentOrderApi.CreateFulfillmentOrder createFulfillmentOrder = buildCreateFulfillmentOrderRequest(orderSummary.Id, location.Id, Constants.WAREHOUSE);

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
        String orderId = createOrder();

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
            createOrderSummary(orderId);
            orderSummary = [SELECT Id FROM OrderSummary WHERE OriginalOrderId =: orderId];
        }
        else {
            orderSummary = orderSummaries[0];
        }

        Schema.Location location = [SELECT Id FROM Location WHERE Name =: Constants.WAREHOUSE LIMIT 1];

        // createFulfillmentOrders request
        FulfillmentOrderApi.CreateFulfillmentOrder createFulfillmentOrder = buildCreateFulfillmentOrderRequest(orderSummary.Id, location.Id, Constants.WAREHOUSE);
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
    static void shouldcancelFulfillmentOrderLineItems() {
        String orderId = createOrder();

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
            createOrderSummary(orderId);
            orderSummary = [SELECT Id FROM OrderSummary WHERE OriginalOrderId =: orderId];
        }
        else {
            orderSummary = orderSummaries[0];
        }

        Schema.Location location = [SELECT Id FROM Location WHERE Name =: Constants.WAREHOUSE LIMIT 1];

        FulfillmentOrderApi api = new FulfillmentOrderApi();

        // createFulfillmentOrders request
        FulfillmentOrderApi.CreateFulfillmentOrder createFulfillmentOrder = buildCreateFulfillmentOrderRequest(orderSummary.Id, location.Id, Constants.WAREHOUSE);
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
    static void shouldCreateMultipleFulfillmentOrders() {
        String order1Id = createOrder();
        String order2Id = createOrder();
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
            createOrderSummary(order1Id);
            createOrderSummary(order2Id);
            orderSummaries = [SELECT Id FROM OrderSummary WHERE OriginalOrderId IN: orderIds];
        }

        Schema.Location location = [SELECT Id FROM Location WHERE Name =: Constants.WAREHOUSE LIMIT 1];

        FulfillmentOrderApi api = new FulfillmentOrderApi();

        // createFulfillmentOrders request
        List<FulfillmentOrderApi.CreateFulfillmentOrder> createFulfillmentOrderList = new List<FulfillmentOrderApi.CreateFulfillmentOrder>();
        for (OrderSummary orderSummary : orderSummaries) {
            orderSummaryIds.add(orderSummary.Id);
            FulfillmentOrderApi.CreateFulfillmentOrder createFulfillmentOrder = buildCreateFulfillmentOrderRequest(orderSummary.Id, location.Id, Constants.WAREHOUSE);
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
    * @description Creates Order for test methods
    *   Test class containing a test setup method cannot 
    *   have any methods annotated with "SeeAllData=true"
    * @return Id of the Order
    */
    private static String createOrder() {
        Schema.Location location = TestDataFactory.createLocation(Constants.WAREHOUSE, Constants.WAREHOUSE);
        insert location;

        List<TestDataFactory.CreateOrderItem> orderItemList = new List<TestDataFactory.CreateOrderItem>();

        // #1 order item
        TestDataFactory.CreateOrderItem product1 = new TestDataFactory.CreateOrderItem();
        product1.type = OrderProductType.ORDER_PRODUCT;
        product1.productCode = '001';
        product1.quantity = 2;
        product1.unitPrice = 10;

        // #2 order item
        TestDataFactory.CreateOrderItem product2 = new TestDataFactory.CreateOrderItem();
        product2.type = OrderProductType.ORDER_PRODUCT;
        product2.productCode = '002';
        product2.quantity = 2;
        product2.unitPrice = 10;

        // #3 order item
        TestDataFactory.CreateOrderItem shipping = new TestDataFactory.CreateOrderItem();
        shipping.type = OrderProductType.DELIVERY_CHARGE;
        shipping.productCode = '003';
        shipping.quantity = 2;
        shipping.unitPrice = 10;
        
        orderItemList.add(product1);
        orderItemList.add(product2);
        orderItemList.add(shipping);

        return TestDataFactory.createOrderAndRelatedObjects(orderItemList, location.Id)?.Id;
    }

    /**
    * @description Creates OrderSummary for test methods
    * @param orderId The Id of the Order
    * @return OutputRepresentation
    */
    private static ConnectApi.OrderSummaryOutputRepresentation createOrderSummary(String orderId) {
        OrderSummaryApi api = new OrderSummaryApi();
        return api.createOrderSummary(orderId);
    }

    /**
    * @description Builds request for create FulfillmentOrder
    * @param orderSummaryId The Id of the OrderSummary
    * @param locationId The Id of the Location
    * @param fulfillmentType The type of the FulfillmentOrder
    * @return CreateFulfillmentOrder model
    */
    private static FulfillmentOrderApi.CreateFulfillmentOrder buildCreateFulfillmentOrderRequest(String orderSummaryId, String locationId, String fulfillmentType) {
        FulfillmentOrderApi.CreateFulfillmentOrder createFulfillmentOrder = new FulfillmentOrderApi.CreateFulfillmentOrder();
        createFulfillmentOrder.fulfillmentType = fulfillmentType;
        createFulfillmentOrder.locationId = locationId;
        createFulfillmentOrder.orderSummaryId = orderSummaryId;
        return createFulfillmentOrder;
    }
}