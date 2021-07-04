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

        Test.startTest();
        if(orderSummaries.isEmpty()) {
            TestDataFactory.createOrderSummary(orderId);
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
        String orderId = TestDataFactory.createOrder();

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
            TestDataFactory.createOrderSummary(orderId);
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
            AND Type =: OrderProductType.ORDER_PRODUCT.toString() LIMIT 1];
        
        Boolean isOrderItemDiscountable = OrderSummaryService.isOrderItemDiscountable(orderItemSummary);

        System.assert(isOrderItemDiscountable, 'Order product is not discountable');

        if (isOrderItemDiscountable) {
            List<ConnectApi.AdjustItemInputRepresentation> adjustItemInputList = TestDataFactory.buildAdjustInput(orderItemSummary, orderSummary, OrderProductSummaryChangeReason.UNKNOWN.toString(), adjustment);
            
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
        String orderId = TestDataFactory.createOrder();

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
            TestDataFactory.createOrderSummary(orderId);
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
            List<ConnectApi.AdjustItemInputRepresentation> adjustItemInputList = TestDataFactory.buildAdjustInput(orderItemSummary, orderSummary, OrderProductSummaryChangeReason.UNKNOWN.toString(), adjustment);
            
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

        System.assert(ensureFundsOutput.success, 'Ensure funds action failed');
    }

    /**
    * @description Test method of OrderSummaryApi.previewReturn
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @SuppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @IsTest(SeeAllData=true)
    static void shouldPreviewReturn() {
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

        OrderSummaryApi orderSummaryApi = new OrderSummaryApi();
        FulfillmentOrderApi fulfillmentOrderApi = new FulfillmentOrderApi();

        // create FulfillmentOrder
        FulfillmentOrderApi.CreateFulfillmentOrder createFulfillmentOrder = new FulfillmentOrderApi.CreateFulfillmentOrder();
        createFulfillmentOrder.locationId = location.Id;
        createFulfillmentOrder.orderSummaryId = orderSummary.Id;
        createFulfillmentOrder.fulfillmentType = FulfillmentOrderType.WAREHOUSE.toString();

        ConnectApi.FulfillmentOrderOutputRepresentation fulfillmentOrderOutput = fulfillmentOrderApi.createFulfillmentOrders(createFulfillmentOrder);
        String fulfillmentOrderId = fulfillmentOrderOutput.fulfillmentOrderIds[0];

        FulfillmentOrder fulfillmentOrder = [SELECT Id FROM FulfillmentOrder WHERE Id =: fulfillmentOrderId];
        fulfillmentOrder.Status = FulfillmentOrderStatus.FULFILLED.toString();
        DatabaseUtils.updateRecords(new List<FulfillmentOrder>{ fulfillmentOrder }, true);

        List<OrderItemSummary> orderItemSummaries = [
            SELECT Type, Quantity, QuantityAvailableToReturn
            FROM OrderItemSummary 
            WHERE OrderSummaryId =: orderSummary.Id
            AND Type =: OrderProductType.ORDER_PRODUCT.toString()];

        Boolean areOrderItemsReturnable = false;

        for (OrderItemSummary orderItemSummary : orderItemSummaries) {
            areOrderItemsReturnable = OrderSummaryService.isOrderItemReturnable(orderItemSummary);
            if (!areOrderItemsReturnable) {
                break;
            }
        }

        System.assert(areOrderItemsReturnable, 'Order product is not returnable');

        if (areOrderItemsReturnable) {
            // prepare change input
            ConnectApi.ChangeInputRepresentation changeInput = OrderSummaryService.buildChangeInput(orderItemSummaries, OrderProductSummaryChangeReason.UNKNOWN.toString(), true);
            
            Test.startTest();
            ConnectApi.PreviewReturnOutputRepresentation output = orderSummaryApi.previewReturn(orderSummary.Id, changeInput);
            Test.stopTest();

            System.assert(output.success, 'Preview return action failed');
        }
    }

    /**
    * @description Test method of OrderSummaryApi.submitReturn
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @SuppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @IsTest(SeeAllData=true)
    static void shouldSubmitReturn() {
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

        OrderSummaryApi orderSummaryApi = new OrderSummaryApi();
        FulfillmentOrderApi fulfillmentOrderApi = new FulfillmentOrderApi();

        // create FulfillmentOrder
        FulfillmentOrderApi.CreateFulfillmentOrder createFulfillmentOrder = new FulfillmentOrderApi.CreateFulfillmentOrder();
        createFulfillmentOrder.locationId = location.Id;
        createFulfillmentOrder.orderSummaryId = orderSummary.Id;
        createFulfillmentOrder.fulfillmentType = FulfillmentOrderType.WAREHOUSE.toString();

        ConnectApi.FulfillmentOrderOutputRepresentation fulfillmentOrderOutput = fulfillmentOrderApi.createFulfillmentOrders(createFulfillmentOrder);
        String fulfillmentOrderId = fulfillmentOrderOutput.fulfillmentOrderIds[0];

        FulfillmentOrder fulfillmentOrder = [SELECT Id FROM FulfillmentOrder WHERE Id =: fulfillmentOrderId];
        fulfillmentOrder.Status = FulfillmentOrderStatus.FULFILLED.toString();
        DatabaseUtils.updateRecords(new List<FulfillmentOrder>{ fulfillmentOrder }, true);

        List<OrderItemSummary> orderItemSummaries = [
            SELECT Type, Quantity, QuantityAvailableToReturn
            FROM OrderItemSummary 
            WHERE OrderSummaryId =: orderSummary.Id
            AND Type =: OrderProductType.ORDER_PRODUCT.toString()];

        Boolean areOrderItemsReturnable = false;

        for (OrderItemSummary orderItemSummary : orderItemSummaries) {
            areOrderItemsReturnable = OrderSummaryService.isOrderItemReturnable(orderItemSummary);
            if (!areOrderItemsReturnable) {
                break;
            }
        }

        System.assert(areOrderItemsReturnable, 'Order product is not returnable');

        if (areOrderItemsReturnable) {
            // prepare change input
            ConnectApi.ChangeInputRepresentation changeInput = OrderSummaryService.buildChangeInput(orderItemSummaries, OrderProductSummaryChangeReason.UNKNOWN.toString(), true);
            
            Test.startTest();
            ConnectApi.SubmitReturnOutputRepresentation output = orderSummaryApi.submitReturn(orderSummary.Id, changeInput);
            Test.stopTest();

            System.assert(output.success, 'Submit return action failed');

            orderItemSummaries = [
                SELECT Status, QuantityReturned
                FROM OrderItemSummary 
                WHERE OrderSummaryId =: orderSummary.Id
                AND Type =: OrderProductType.ORDER_PRODUCT.toString()];

            for (OrderItemSummary orderItemSummary : orderItemSummaries) {
                System.assert(orderItemSummary.Status.equalsIgnoreCase(OrderProductStatus.RETURNED.toString()), 'Status of the order product is not RETURNED');
                System.assert(orderItemSummary.QuantityReturned > 0, 'The quantity returned should greater than zero');
            }
        }
    }

    /**
    * @description Test method of OrderSummaryApi.previewCancel
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @SuppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @IsTest(SeeAllData=true)
    static void shouldPreviewCancel() {
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

        OrderSummaryApi orderSummaryApi = new OrderSummaryApi();

        List<OrderItemSummary> orderItemSummaries = [
            SELECT Type, Quantity, QuantityAvailableToCancel
            FROM OrderItemSummary 
            WHERE OrderSummaryId =: orderSummary.Id
            AND Type =: OrderProductType.ORDER_PRODUCT.toString()];

        Boolean areOrderItemsCancelable = false;

        for (OrderItemSummary orderItemSummary : orderItemSummaries) {
            areOrderItemsCancelable = OrderSummaryService.isOrderItemCancelable(orderItemSummary);
            if (!areOrderItemsCancelable) {
                break;
            }
        }

        System.assert(areOrderItemsCancelable, 'Order product is not returnable');

        if (areOrderItemsCancelable) {
            // prepare change input
            ConnectApi.ChangeInputRepresentation changeInput = OrderSummaryService.buildChangeInput(orderItemSummaries, OrderProductSummaryChangeReason.UNKNOWN.toString(), true);
            
            Test.startTest();
            ConnectApi.PreviewCancelOutputRepresentation output = orderSummaryApi.previewCancel(orderSummary.Id, changeInput);
            Test.stopTest();

            System.assert(output.success, 'Preview cancel action failed');
        }
    }

    /**
    * @description Test method of OrderSummaryApi.submitCancel
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @SuppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @IsTest(SeeAllData=true)
    static void shouldSubmitCancel() {
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

        OrderSummaryApi orderSummaryApi = new OrderSummaryApi();

        List<OrderItemSummary> orderItemSummaries = [
            SELECT Type, Quantity, QuantityAvailableToCancel
            FROM OrderItemSummary 
            WHERE OrderSummaryId =: orderSummary.Id
            AND Type =: OrderProductType.ORDER_PRODUCT.toString()];

        Boolean areOrderItemsCancelable = false;

        for (OrderItemSummary orderItemSummary : orderItemSummaries) {
            areOrderItemsCancelable = OrderSummaryService.isOrderItemCancelable(orderItemSummary);
            if (!areOrderItemsCancelable) {
                break;
            }
        }

        System.assert(areOrderItemsCancelable, 'Order product is not cancelable');

        if (areOrderItemsCancelable) {
            // prepare change input
            ConnectApi.ChangeInputRepresentation changeInput = OrderSummaryService.buildChangeInput(orderItemSummaries, OrderProductSummaryChangeReason.UNKNOWN.toString(), true);
            
            Test.startTest();
            ConnectApi.SubmitCancelOutputRepresentation output = orderSummaryApi.submitCancel(orderSummary.Id, changeInput);
            Test.stopTest();

            System.assert(output.success, 'Submit cancel action failed');

            orderItemSummaries = [
                SELECT Status, QuantityCanceled
                FROM OrderItemSummary 
                WHERE OrderSummaryId =: orderSummary.Id
                AND Type =: OrderProductType.ORDER_PRODUCT.toString()];

            for (OrderItemSummary orderItemSummary : orderItemSummaries) {
                System.assert(orderItemSummary.Status.equalsIgnoreCase(OrderProductStatus.CANCELED.toString()), 'Status of the order product is not CANCELED');
                System.assert(orderItemSummary.QuantityCanceled > 0, 'The quantity canceled should greater than zero');
            }
        }
    }

    /**
    * @description Test method of OrderSummaryApi.createCreditMemo
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @SuppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @IsTest(SeeAllData=true)
    static void shouldCreateCreditMemo() {
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

        OrderSummaryApi orderSummaryApi = new OrderSummaryApi();
        FulfillmentOrderApi fulfillmentOrderApi = new FulfillmentOrderApi();

        // create FulfillmentOrder
        FulfillmentOrderApi.CreateFulfillmentOrder createFulfillmentOrder = new FulfillmentOrderApi.CreateFulfillmentOrder();
        createFulfillmentOrder.locationId = location.Id;
        createFulfillmentOrder.orderSummaryId = orderSummary.Id;
        createFulfillmentOrder.fulfillmentType = FulfillmentOrderType.WAREHOUSE.toString();

        ConnectApi.FulfillmentOrderOutputRepresentation fulfillmentOrderOutput = fulfillmentOrderApi.createFulfillmentOrders(createFulfillmentOrder);
        String fulfillmentOrderId = fulfillmentOrderOutput.fulfillmentOrderIds[0];

        FulfillmentOrder fulfillmentOrder = [SELECT Id FROM FulfillmentOrder WHERE Id =: fulfillmentOrderId];
        fulfillmentOrder.Status = FulfillmentOrderStatus.FULFILLED.toString();
        DatabaseUtils.updateRecords(new List<FulfillmentOrder>{ fulfillmentOrder }, true);

        List<OrderItemSummary> orderItemSummaries = [
            SELECT Type, Quantity, QuantityAvailableToReturn
            FROM OrderItemSummary 
            WHERE OrderSummaryId =: orderSummary.Id
            AND Type =: OrderProductType.ORDER_PRODUCT.toString()];

        Boolean areOrderItemsReturnable = false;

        for (OrderItemSummary orderItemSummary : orderItemSummaries) {
            areOrderItemsReturnable = OrderSummaryService.isOrderItemReturnable(orderItemSummary);
            if (!areOrderItemsReturnable) {
                break;
            }
        }

        System.assert(areOrderItemsReturnable, 'Order product is not returnable');

        if (areOrderItemsReturnable) {
            // prepare change input
            ConnectApi.ChangeInputRepresentation changeInput = OrderSummaryService.buildChangeInput(orderItemSummaries, OrderProductSummaryChangeReason.UNKNOWN.toString(), true);

            // return
            ConnectApi.SubmitReturnOutputRepresentation submitReturnOutput = orderSummaryApi.submitReturn(orderSummary.Id, changeInput);
            
            Test.startTest();
            ConnectApi.CreateCreditMemoOutputRepresentation output = orderSummaryApi.createCreditMemo(orderSummary.Id, new List<Id>{ submitReturnOutput.changeOrderId });
            Test.stopTest();

            String creditMemoId = output.creditMemoId;

            System.assert(output.success, 'Create credit memo action failed');

            List<CreditMemo> creditMemos = [SELECT Id FROM CreditMemo WHERE Id =: creditMemoId];

            System.assert(!creditMemos.isEmpty(), 'No CreditMemo record found');
        }
    }
}