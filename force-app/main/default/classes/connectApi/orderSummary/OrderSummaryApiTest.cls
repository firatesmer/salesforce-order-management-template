/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description OrderSummary Api test class
*/
@isTest
private class OrderSummaryApiTest {
    /**
    * @description Test method of OrderSummaryApi.createOrderSummary
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @SuppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @IsTest(SeeAllData=true)
    static void shouldCreateOrderSummary() {
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

        Test.startTest();
        if(orderSummaries.isEmpty()) {
            createOrderSummary(orderId);
            orderSummary = [SELECT TaxLocaleType FROM OrderSummary WHERE OriginalOrderId =: orderId];
        }
        else {
            orderSummary = orderSummaries[0];
        }
        Test.stopTest();

        System.assert(orderSummary != null, 'Order summary not found');
    }

    /**
    * @description Test method of OrderSummaryApi.createOrderSummary
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @SuppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @IsTest(SeeAllData=true)
    static void shouldCreateOrderSummaryWithName() {
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

        Test.startTest();
        if(orderSummaries.isEmpty()) {
            new OrderSummaryApi().createOrderSummary(orderId, '000001', 'MANAGED', OrderSummaryStatus.CREATED);
            orderSummary = [SELECT TaxLocaleType FROM OrderSummary WHERE OriginalOrderId =: orderId];
        }
        else {
            orderSummary = orderSummaries[0];
        }
        Test.stopTest();

        System.assert(orderSummary != null, 'Order summary not found');
    }

    /**
    * @description Test method of OrderSummaryApi.adjustPreview
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @SuppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @IsTest(SeeAllData=true)
    static void shouldAdjustPreview() {
        String orderId = createOrder();

        Double adjustment = -2;

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
            orderSummary = [SELECT TaxLocaleType FROM OrderSummary WHERE OriginalOrderId =: orderId];
        }
        else {
            orderSummary = orderSummaries[0];
        }

        OrderItemSummary orderItemSummary = [
            SELECT 
            Quantity, QuantityReturnInitiated, QuantityReturned, 
            QuantityAllocated, QuantityFulfilled, TotalAmtWithTax 
            FROM OrderItemSummary 
            WHERE OrderSummaryId =: orderSummary.Id
            AND Type =: OrderProductType.ORDER_PRODUCT.toString()
            LIMIT 1];
        
        Boolean isOrderItemDiscountable = OrderSummaryService.isOrderItemDiscountable(orderItemSummary);

        System.assert(isOrderItemDiscountable, 'Order product is not discountable.');

        if (isOrderItemDiscountable) {
            List<ConnectApi.AdjustItemInputRepresentation> adjustItemInputList = buildAdjustInput(orderItemSummary, orderSummary, adjustment);
            
            OrderSummaryApi api = new OrderSummaryApi();

            Test.startTest();
            ConnectApi.AdjustOrderSummaryOutputRepresentation adjustPreviewOutput = api.adjustPreview(orderSummary.Id, adjustItemInputList);
            ConnectApi.ChangeItemOutputRepresentation adjustItem = adjustPreviewOutput.changeBalances;
            Test.stopTest();

            System.assert(adjustPreviewOutput.success, 'Adjust preview failed');
            System.assert(adjustItem.totalAdjustedProductAmount == (adjustment * -1), 'Adjust amounts are not matching');
        }
    }

    /**
    * @description Test method of OrderSummaryApi.adjustSubmitm
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @SuppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @IsTest(SeeAllData=true)
    static void shouldAdjustSubmit() {
        String orderId = createOrder();

        Double adjustment = -1;

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
            orderSummary = [SELECT TaxLocaleType FROM OrderSummary WHERE OriginalOrderId =: orderId];
        }
        else {
            orderSummary = orderSummaries[0];
        }

        OrderItemSummary orderItemSummary = [
            SELECT 
            Quantity, QuantityReturnInitiated, QuantityReturned, 
            QuantityAllocated, QuantityFulfilled, TotalAmtWithTax 
            FROM OrderItemSummary 
            WHERE OrderSummaryId =: orderSummary.Id
            AND Type =: OrderProductType.ORDER_PRODUCT.toString() 
            LIMIT 1];
        
        Boolean isOrderItemDiscountable = OrderSummaryService.isOrderItemDiscountable(orderItemSummary);

        if (isOrderItemDiscountable) {
            List<ConnectApi.AdjustItemInputRepresentation> adjustItemInputList = buildAdjustInput(orderItemSummary, orderSummary, adjustment);
            
            OrderSummaryApi api = new OrderSummaryApi();

            Test.startTest();
            ConnectApi.AdjustOrderSummaryOutputRepresentation adjustSubmitOutput = api.adjustSubmit(orderSummary.Id, adjustItemInputList);
            Test.stopTest();

            orderItemSummary = [
                SELECT 
                TotalLineAdjustmentAmount
                FROM OrderItemSummary 
                WHERE Id =: orderItemSummary.Id
                AND OrderSummaryId =: orderSummary.Id];

            System.assert(adjustSubmitOutput.success, 'Adjust submit failed');
            System.assert(orderItemSummary.TotalLineAdjustmentAmount == adjustment, String.format('Adjustment amount should be {0}', new List<String>{ String.valueOf(adjustment) }));
        }
    }

    /**
    * @description Test method of OrderSummaryApi.ensureFundsAsync
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @SuppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @IsTest(SeeAllData=true)
    static void shouldEnsureFunds() {
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

        OrderSummaryApi orderSummaryApi = new OrderSummaryApi();
        FulfillmentOrderApi fulfillmentOrderApi = new FulfillmentOrderApi();

        // create FulfillmentOrder
        FulfillmentOrderApi.CreateFulfillmentOrder createFulfillmentOrder = new FulfillmentOrderApi.CreateFulfillmentOrder();
        createFulfillmentOrder.locationId = location.Id;
        createFulfillmentOrder.orderSummaryId = orderSummary.Id;
        createFulfillmentOrder.fulfillmentType = FulfillmentOrderType.WAREHOUSE.toString();

        ConnectApi.FulfillmentOrderOutputRepresentation fulfillmentOrderOutput = fulfillmentOrderApi.createFulfillmentOrders(createFulfillmentOrder);

        String fulfillmentOrderId = fulfillmentOrderOutput.fulfillmentOrderIds[0];

        ConnectApi.FulfillmentOrderInvoiceOutputRepresentation invoiceOutput = fulfillmentOrderApi.createInvoice(fulfillmentOrderId);

        List<Invoice> invoices = [SELECT Id FROM Invoice WHERE Id =: invoiceOutput.invoiceId];

        Test.startTest();
        ConnectApi.EnsureFundsAsyncOutputRepresentation ensureFundsOutput = orderSummaryApi.ensureFundsAsync(orderSummary.Id, invoices[0].Id);
        Test.stopTest();

        OrderPaymentSummary orderPaymentSummary = [SELECT AuthorizationAmount, AvailableToCaptureAmount, BalanceAmount, CapturedAmount, PendingCaptureAmount FROM OrderPaymentSummary WHERE OrderSummaryId =: orderSummary.Id];
        
        System.assert(ensureFundsOutput.success, 'Ensure funds action failed');
        System.assert(orderPaymentSummary.CapturedAmount > 0 || orderPaymentSummary.PendingCaptureAmount > 0 , 'CapturedAmount and PendingCaptureAmount is zero');
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
    * @param orderId The Id of the order
    * @return OutputRepresentation
    */
    private static ConnectApi.OrderSummaryOutputRepresentation createOrderSummary(String orderId) {
        return new OrderSummaryApi().createOrderSummary(orderId);
    }

    /**
    * @description Builds input for adjustPreview & adjustSubmit
    * @param orderItemSummary OrderItemSummary
    * @param orderSummary OrderSummary
    * @param adjustment Adjustment amout of the items
    * @return OutputRepresentation
    */
    private static List<ConnectApi.AdjustItemInputRepresentation> buildAdjustInput(OrderItemSummary orderItemSummary, OrderSummary orderSummary, Double adjustment) {
        List<ConnectApi.AdjustItemInputRepresentation> adjustItemInputList = new List<ConnectApi.AdjustItemInputRepresentation>();
        ConnectApi.AdjustItemInputRepresentation adjustItemInput = new ConnectApi.AdjustItemInputRepresentation();

        adjustItemInput.adjustmentType = orderSummary.TaxLocaleType != null && orderSummary.TaxLocaleType.equalsIgnoreCase(Constants.GROSS)
                ? 'AmountWithTax'
                : 'AmountWithoutTax';
        adjustItemInput.amount = adjustment;
        adjustItemInput.orderItemSummaryId = orderItemSummary.Id;
        adjustItemInput.reason = 'Unknown';
        adjustItemInputList.add(adjustItemInput);

        return adjustItemInputList;
    }
}