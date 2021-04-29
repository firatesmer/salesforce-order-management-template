/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 20/04/2021
* @description Test class of SalesforceAdapter
*/
@isTest
private class SalesforceAdapterTest {
    /**
    * @description Test setup to create Order
    */
    @testSetup
    static void prepareOrder() {
        createOrder();
    }

    /**
    * @description Test method of SalesforceAdapter capture
    */
    @isTest
    static void shouldCapture() {
        Id orderId = [SELECT Id FROM Order][0].Id;

        PaymentGroup paymentGroup = TestDataFactory.createPaymentGroup(orderId);
        insert paymentGroup;

        PaymentAuthorization paymentAuthorization = TestDataFactory.createPaymentAuthorization((Double)291.39, paymentGroup.Id);
        insert paymentAuthorization;

        commercepayments.CaptureRequest captureRequest = new commercepayments.CaptureRequest((Double)291.39, paymentAuthorization.id);
        commercepayments.PaymentGatewayContext context = new commercepayments.PaymentGatewayContext(
            captureRequest,
            commercepayments.RequestType.Capture);

        Test.startTest();
        SalesforceAdapter adapter = new SalesforceAdapter();
        commercepayments.GatewayResponse response = adapter.processRequest(context);
        Test.stopTest();

        System.assert(response != null, 'Gateway response shouldn\'t be null');
    }

    /**
    * @description Test method of SalesforceAdapter refund
    */
    @isTest
    static void shouldRefund() {
        Id orderId = [SELECT Id FROM Order][0].Id;

        PaymentGroup paymentGroup = TestDataFactory.createPaymentGroup(orderId);
        insert paymentGroup;

        PaymentAuthorization paymentAuthorization = TestDataFactory.createPaymentAuthorization((Double)291.39, paymentGroup.Id);
        insert paymentAuthorization;

        commercepayments.ReferencedRefundRequest refundRequest = new commercepayments.ReferencedRefundRequest((Double)291.39, paymentAuthorization.id);
        commercepayments.PaymentGatewayContext context = new commercepayments.PaymentGatewayContext(
            refundRequest,
            commercepayments.RequestType.ReferencedRefund);

        Test.startTest();
        SalesforceAdapter adapter = new SalesforceAdapter();
        commercepayments.GatewayResponse response = adapter.processRequest(context);
        Test.stopTest();

        System.assert(response != null, 'Gateway response shouldn\'t be null');
    }

    /**
    * @description Test method of SalesforceAdapter sale
    */
    @isTest
    static void shouldSale() {
        commercepayments.SaleRequest saleRequest = new commercepayments.SaleRequest((Double)291.39);
        commercepayments.PaymentGatewayContext context = new commercepayments.PaymentGatewayContext(
            saleRequest,
            commercepayments.RequestType.Sale);

        Test.startTest();
        SalesforceAdapter adapter = new SalesforceAdapter();
        commercepayments.GatewayResponse response = adapter.processRequest(context);
        Test.stopTest();

        System.assert(response != null, 'Gateway response shouldn\'t be null');
    }

    /**
    * @description Test method of SalesforceAdapter authorization
    */
    @isTest
    static void shouldAuthorize() {
        commercepayments.AuthorizationRequest authRequest = new commercepayments.AuthorizationRequest((Double)291.39);
        commercepayments.PaymentGatewayContext context = new commercepayments.PaymentGatewayContext(
            authRequest,
            commercepayments.RequestType.Authorize);

        Test.startTest();
        SalesforceAdapter adapter = new SalesforceAdapter();
        commercepayments.GatewayResponse response = adapter.processRequest(context);
        Test.stopTest();

        System.assert(response != null, 'Gateway response shouldn\'t be null');
    }

    /**
    * @description Test method of SalesforceAdapter tokenize
    */
    @isTest
    static void shouldTokenize() {
        commercepayments.PaymentMethodTokenizationRequest tokenRequest = null;
        commercepayments.PaymentGatewayContext context = new commercepayments.PaymentGatewayContext(
            tokenRequest,
            commercepayments.RequestType.Tokenize);

        Test.startTest();
        SalesforceAdapter adapter = new SalesforceAdapter();
        commercepayments.GatewayResponse response = adapter.processRequest(context);
        Test.stopTest();

        System.assert(response != null, 'Gateway response shouldn\'t be null');
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
}