/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description OrderSummary Api test class
*   suppress reason : TODO needs refactor
*/
@suppressWarnings('PMD.CognitiveComplexity, PMD.CyclomaticComplexity')
@isTest
private class OrderSummaryApiTest {
    /**
    * @description Test method of OrderSummaryApi.createOrderSummary
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldCreateOrderSummary() {
        String orderId = TestDataFactory.createOrder();

        Test.startTest();
        OrderSummary orderSummary = TestDataFactory.createOrderSummary(orderId);
        Test.stopTest();

        System.assert(orderSummary != null, 'Order summary not found');
    }

    /**
    * @description Test method of OrderSummaryApi.createOrderSummary
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldCreateOrderSummaryWithAdditionalInfo() {
        String orderId = TestDataFactory.createOrder();


        Test.startTest();
        new OrderSummaryApi().createOrderSummary(orderId, 'ORDER-0001', LifeCycleType.MANAGED, OrderSummaryStatus.CREATED);
        Test.stopTest();

        OrderSummary orderSummary = [SELECT Id FROM OrderSummary WHERE OriginalOrderId =: orderId];

        System.assert(orderSummary != null, 'Order summary not found');
    }

    /**
    * @description Test method of OrderSummaryApi.adjustPreview
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldAdjustPreview() {
        String orderId = TestDataFactory.createOrder();

        Double adjustment = -2;

        OrderSummary orderSummary = TestDataFactory.createOrderSummary(orderId);

        OrderItemSummary orderItemSummary = [
            SELECT 
                Quantity, QuantityReturnInitiated, QuantityReturned, 
                QuantityAllocated, QuantityFulfilled, TotalAmtWithTax 
            FROM OrderItemSummary 
            WHERE OrderSummaryId =: orderSummary.Id
            AND Type =: OrderItemType.ORDER_PRODUCT.enumValue LIMIT 1];
        
        Boolean isOrderItemDiscountable = OrderSummaryService.isOrderItemDiscountable(orderItemSummary);

        System.assert(isOrderItemDiscountable, 'Order item is not discountable');

        if (isOrderItemDiscountable) {
            List<ConnectApi.AdjustItemInputRepresentation> adjustItemInputList = TestDataFactory.buildAdjustInput(orderItemSummary, orderSummary, OrderItemSummaryChangeReason.UNKNOWN, adjustment);
            
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
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldAdjustSubmit() {
        String orderId = TestDataFactory.createOrder();

        Double adjustment = -1;

        OrderSummary orderSummary = TestDataFactory.createOrderSummary(orderId);

        OrderItemSummary orderItemSummary = [
            SELECT 
            Quantity, QuantityReturnInitiated, QuantityReturned, 
            QuantityAllocated, QuantityFulfilled, TotalAmtWithTax 
            FROM OrderItemSummary 
            WHERE OrderSummaryId =: orderSummary.Id
            AND Type =: OrderItemType.ORDER_PRODUCT.enumValue 
            LIMIT 1];
        
        Boolean isOrderItemDiscountable = OrderSummaryService.isOrderItemDiscountable(orderItemSummary);

        if (isOrderItemDiscountable) {
            List<ConnectApi.AdjustItemInputRepresentation> adjustItemInputList = TestDataFactory.buildAdjustInput(orderItemSummary, orderSummary, OrderItemSummaryChangeReason.UNKNOWN, adjustment);
            
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
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldEnsureFunds() {
        String orderId = TestDataFactory.createOrder();

        OrderSummary orderSummary = TestDataFactory.createOrderSummary(orderId); 

        Schema.Location location = [SELECT Id FROM Location WHERE Name =: Constants.WAREHOUSE LIMIT 1];

        OrderSummaryApi orderSummaryApi = new OrderSummaryApi();
        FulfillmentOrderApi fulfillmentOrderApi = new FulfillmentOrderApi();

        ConnectApi.FulfillmentOrderOutputRepresentation fulfillmentOrderOutput = fulfillmentOrderApi.createFulfillmentOrders(orderSummary.Id, location.Id, FulfillmentOrderType.WAREHOUSE);

        String fulfillmentOrderId = fulfillmentOrderOutput.fulfillmentOrderIds[0];

        ConnectApi.FulfillmentOrderInvoiceOutputRepresentation invoiceOutput = fulfillmentOrderApi.createInvoice(fulfillmentOrderId);

        List<Invoice> invoices = [SELECT Id FROM Invoice WHERE Id =: invoiceOutput.invoiceId];

        Test.startTest();
        ConnectApi.EnsureFundsAsyncOutputRepresentation ensureFundsOutput = orderSummaryApi.ensureFundsAsync(orderSummary.Id, invoices[0].Id);
        Test.stopTest();

        System.assert(ensureFundsOutput.success, 'Ensure funds action is failed');
    }

    /**
    * @description Test method of OrderSummaryApi.previewReturn
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldPreviewReturn() {
        String orderId = TestDataFactory.createOrder();

        OrderSummary orderSummary = TestDataFactory.createOrderSummary(orderId);

        Schema.Location location = [SELECT Id FROM Location WHERE Name =: Constants.WAREHOUSE LIMIT 1];

        OrderSummaryApi orderSummaryApi = new OrderSummaryApi();
        FulfillmentOrderApi fulfillmentOrderApi = new FulfillmentOrderApi();

        ConnectApi.FulfillmentOrderOutputRepresentation fulfillmentOrderOutput = fulfillmentOrderApi.createFulfillmentOrders(orderSummary.Id, location.Id, FulfillmentOrderType.WAREHOUSE);
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
            // prepare change input
            ConnectApi.ChangeInputRepresentation changeInput = OrderSummaryService.buildChangeInput(orderItemSummaries, OrderItemSummaryChangeReason.UNKNOWN, true);
            
            Test.startTest();
            ConnectApi.PreviewReturnOutputRepresentation output = orderSummaryApi.previewReturn(orderSummary.Id, changeInput);
            Test.stopTest();

            System.assert(output.success, 'Preview return action is failed');
        }
    }

    /**
    * @description Test method of OrderSummaryApi.submitReturn
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldSubmitReturn() {
        String orderId = TestDataFactory.createOrder();

        OrderSummary orderSummary = TestDataFactory.createOrderSummary(orderId); 

        Schema.Location location = [SELECT Id FROM Location WHERE Name =: Constants.WAREHOUSE LIMIT 1];

        OrderSummaryApi orderSummaryApi = new OrderSummaryApi();
        FulfillmentOrderApi fulfillmentOrderApi = new FulfillmentOrderApi();

        ConnectApi.FulfillmentOrderOutputRepresentation fulfillmentOrderOutput = fulfillmentOrderApi.createFulfillmentOrders(orderSummary.Id, location.Id, FulfillmentOrderType.WAREHOUSE);
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
            // prepare change input
            ConnectApi.ChangeInputRepresentation changeInput = OrderSummaryService.buildChangeInput(orderItemSummaries, OrderItemSummaryChangeReason.UNKNOWN, true);
            
            Test.startTest();
            ConnectApi.SubmitReturnOutputRepresentation output = orderSummaryApi.submitReturn(orderSummary.Id, changeInput);
            Test.stopTest();

            System.assert(output.success, 'Submit return action is failed');

            orderItemSummaries = [
                SELECT Status, QuantityReturned
                FROM OrderItemSummary 
                WHERE OrderSummaryId =: orderSummary.Id
                AND Type =: OrderItemType.ORDER_PRODUCT.enumValue];

            for (OrderItemSummary orderItemSummary : orderItemSummaries) {
                System.assert(orderItemSummary.Status.equalsIgnoreCase(OrderItemStatus.RETURNED.enumValue), 'Status of the Order item is not RETURNED');
                System.assert(orderItemSummary.QuantityReturned > 0, 'The quantity returned should greater than zero');
            }
        }
    }

    /**
    * @description Test method of OrderSummaryApi.previewCancel
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldPreviewCancel() {
        String orderId = TestDataFactory.createOrder();

        OrderSummary orderSummary = TestDataFactory.createOrderSummary(orderId);

        OrderSummaryApi orderSummaryApi = new OrderSummaryApi();

        List<OrderItemSummary> orderItemSummaries = [
            SELECT Type, Quantity, QuantityAvailableToCancel
            FROM OrderItemSummary 
            WHERE OrderSummaryId =: orderSummary.Id
            AND Type =: OrderItemType.ORDER_PRODUCT.enumValue];

        Boolean areOrderItemsCancelable = false;

        for (OrderItemSummary orderItemSummary : orderItemSummaries) {
            areOrderItemsCancelable = OrderSummaryService.isOrderItemCancelable(orderItemSummary);
            if (!areOrderItemsCancelable) {
                break;
            }
        }

        System.assert(areOrderItemsCancelable, 'Order item is not returnable');

        if (areOrderItemsCancelable) {
            // prepare change input
            ConnectApi.ChangeInputRepresentation changeInput = OrderSummaryService.buildChangeInput(orderItemSummaries, OrderItemSummaryChangeReason.UNKNOWN, true);
            
            Test.startTest();
            ConnectApi.PreviewCancelOutputRepresentation output = orderSummaryApi.previewCancel(orderSummary.Id, changeInput);
            Test.stopTest();

            System.assert(output.success, 'Preview cancel action is failed');
        }
    }

    /**
    * @description Test method of OrderSummaryApi.submitCancel
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldSubmitCancel() {
        String orderId = TestDataFactory.createOrder();

        OrderSummary orderSummary = TestDataFactory.createOrderSummary(orderId);

        OrderSummaryApi orderSummaryApi = new OrderSummaryApi();

        List<OrderItemSummary> orderItemSummaries = [
            SELECT Type, Quantity, QuantityAvailableToCancel
            FROM OrderItemSummary 
            WHERE OrderSummaryId =: orderSummary.Id
            AND Type =: OrderItemType.ORDER_PRODUCT.enumValue];

        Boolean areOrderItemsCancelable = false;

        for (OrderItemSummary orderItemSummary : orderItemSummaries) {
            areOrderItemsCancelable = OrderSummaryService.isOrderItemCancelable(orderItemSummary);
            if (!areOrderItemsCancelable) {
                break;
            }
        }

        System.assert(areOrderItemsCancelable, 'Order item is not cancelable');

        if (areOrderItemsCancelable) {
            // prepare change input
            ConnectApi.ChangeInputRepresentation changeInput = OrderSummaryService.buildChangeInput(orderItemSummaries, OrderItemSummaryChangeReason.UNKNOWN, true);
            
            Test.startTest();
            ConnectApi.SubmitCancelOutputRepresentation output = orderSummaryApi.submitCancel(orderSummary.Id, changeInput);
            Test.stopTest();

            System.assert(output.success, 'Submit cancel action is failed');

            orderItemSummaries = [
                SELECT Status, QuantityCanceled
                FROM OrderItemSummary 
                WHERE OrderSummaryId =: orderSummary.Id
                AND Type =: OrderItemType.ORDER_PRODUCT.enumValue];

            for (OrderItemSummary orderItemSummary : orderItemSummaries) {
                System.assert(orderItemSummary.Status.equalsIgnoreCase(OrderItemStatus.CANCELED.enumValue), 'Status of the Order item is not CANCELED');
                System.assert(orderItemSummary.QuantityCanceled > 0, 'The quantity canceled should greater than zero');
            }
        }
    }

    /**
    * @description Test method of OrderSummaryApi.createCreditMemo
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldCreateCreditMemo() {
        String orderId = TestDataFactory.createOrder();

        OrderSummary orderSummary = TestDataFactory.createOrderSummary(orderId);

        Schema.Location location = [SELECT Id FROM Location WHERE Name =: Constants.WAREHOUSE LIMIT 1];

        FulfillmentOrderApi fulfillmentOrderApi = new FulfillmentOrderApi();

        String fulfillmentOrderId = fulfillmentOrderApi.createFulfillmentOrders(orderSummary.Id, location.Id, FulfillmentOrderType.WAREHOUSE).fulfillmentOrderIds[0];

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
            OrderSummaryApi orderSummaryApi = new OrderSummaryApi();

            // prepare change input
            ConnectApi.ChangeInputRepresentation changeInput = OrderSummaryService.buildChangeInput(orderItemSummaries, OrderItemSummaryChangeReason.UNKNOWN, true);

            // return
            ConnectApi.SubmitReturnOutputRepresentation submitReturnOutput = orderSummaryApi.submitReturn(orderSummary.Id, changeInput);
            
            Test.startTest();
            ConnectApi.CreateCreditMemoOutputRepresentation output = orderSummaryApi.createCreditMemo(orderSummary.Id, new List<Id>{ submitReturnOutput.changeOrderId });
            Test.stopTest();

            String creditMemoId = output.creditMemoId;

            System.assert(output.success, 'Create credit memo action is failed');

            List<CreditMemo> creditMemos = [SELECT Id FROM CreditMemo WHERE Id =: creditMemoId];

            System.assert(!creditMemos.isEmpty(), 'No CreditMemo record found');
        }
    }

    /**
    * @description Test method of OrderSummaryApi.ensureRefundsAsync
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldEnsureRefunds() {
        String orderId = TestDataFactory.createOrder();

        OrderSummary orderSummary = TestDataFactory.createOrderSummary(orderId);

        Schema.Location location = [SELECT Id FROM Location WHERE Name =: Constants.WAREHOUSE LIMIT 1];

        String fulfillmentOrderId = new FulfillmentOrderApi().createFulfillmentOrders(orderSummary.Id, location.Id, FulfillmentOrderType.WAREHOUSE).fulfillmentOrderIds[0];

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
            OrderSummaryApi orderSummaryApi = new OrderSummaryApi();

            // prepare change input
            ConnectApi.ChangeInputRepresentation changeInput = OrderSummaryService.buildChangeInput(orderItemSummaries, OrderItemSummaryChangeReason.UNKNOWN, true);

            // return
            ConnectApi.SubmitReturnOutputRepresentation submitReturnOutput = orderSummaryApi.submitReturn(orderSummary.Id, changeInput);

            // create credit memo
            ConnectApi.CreateCreditMemoOutputRepresentation creditMemoOutput = orderSummaryApi.createCreditMemo(orderSummary.Id, new List<Id>{ submitReturnOutput.changeOrderId });

            Test.startTest();
            ConnectApi.EnsureRefundsAsyncOutputRepresentation output = orderSummaryApi.ensureRefundsAsync(orderSummary.Id, creditMemoOutput.creditMemoId, 0);
            Test.stopTest();

            System.assert(output.success, 'Ensure refunds action is failed');
        }
    }
}