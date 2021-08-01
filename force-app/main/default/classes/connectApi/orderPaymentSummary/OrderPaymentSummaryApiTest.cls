/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 11/07/2021
* @description OrderPaymentSummary Api test class
*/
@isTest
private class OrderPaymentSummaryApiTest {
    /**
    * @description Test method of OrderPaymentSummaryApi.createOrderPaymentSummary
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldCreateOrderPaymentSummary() {
        String orderId = TestDataFactory.createOrder();

        OrderSummary orderSummary = TestDataFactory.createOrderSummary(orderId);

        IOrderPaymentSummaryApi api = (IOrderPaymentSummaryApi)Application.ConnectApi.newInstance(IOrderPaymentSummaryApi.class);

        Payment payment = TestDataFactory.createPayment(1);
        insert payment;

        Test.startTest();
        ConnectApi.CreateOrderPaymentSummaryOutputRepresentation output = api.createOrderPaymentSummary(orderSummary.Id, '', new List<String>{ payment.Id });
        Test.stopTest();

        System.assert(output.success, 'Create order payment summary action is failed');
    }
}