/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description Enum test class
*/
@isTest
private class BaseEnumTest {
    /**
    * @description Test method of BaseEnum 
    *   and classes those extend
    */
    @isTest
    static void shouldInitiateEnums() {
        List<CardPaymentMethodStatus> cardPaymentMethodStatusList = CardPaymentMethodStatus.values();
        List<CardPaymentMethodType> cardPaymentMethodTypeList = CardPaymentMethodType.values();
        List<FulfillmentOrderStatus> fulfillmentOrderStatusList = FulfillmentOrderStatus.values();
        List<FulfillmentOrderType> fulfillmentOrderTypeList = FulfillmentOrderType.values();
        List<InvoiceStatus> invoiceStatusList = InvoiceStatus.values();
        List<LocationType> locationTypeList = LocationType.values();
        List<OrderProductStatus> orderProductStatusList = OrderProductStatus.values();
        List<OrderProductSummaryChangeReason> orderProductSummaryChangeList = OrderProductSummaryChangeReason.values();
        List<OrderProductType> orderProductTypeList = OrderProductType.values();
        List<OrderSummaryStatus> orderSummaryStatusList = OrderSummaryStatus.values();
        List<PaymentStatus> paymentStatusList = PaymentStatus.values();
        List<PaymentType> paymentTypeList = PaymentType.values();
        List<ProcessExceptionStatus> processExceptionStatusList = ProcessExceptionStatus.values();
        List<ProcessExceptionType> processExceptionTypeList = ProcessExceptionType.values();
        List<ReturnOrderStatus> returnOrderStatusList = ReturnOrderStatus.values();
        List<ShipmentStatus> shipmentStatusList = ShipmentStatus.values();

        System.assert(!cardPaymentMethodStatusList.isEmpty(), 'CardPaymentMethodStatus list is empty');
        System.assert(!cardPaymentMethodTypeList.isEmpty(), 'CardPaymentMethodType list is empty');
        System.assert(!fulfillmentOrderStatusList.isEmpty(), 'FulfillmentOrderStatus list is empty');
        System.assert(!fulfillmentOrderTypeList.isEmpty(), 'FulfillmentOrderType list is empty');
        System.assert(!invoiceStatusList.isEmpty(), 'InvoiceStatus list is empty');
        System.assert(!orderProductStatusList.isEmpty(), 'OrderProductStatus list is empty');
        System.assert(!orderProductSummaryChangeList.isEmpty(), 'OrderProductSummaryChangeReason list is empty');
        System.assert(!orderProductTypeList.isEmpty(), 'OrderProductType list is empty');
        System.assert(!orderSummaryStatusList.isEmpty(), 'OrderSummaryStatus list is empty');
        System.assert(!paymentStatusList.isEmpty(), 'PaymentStatus list is empty');
        System.assert(!paymentTypeList.isEmpty(), 'PaymentType list is empty');
        System.assert(!processExceptionStatusList.isEmpty(), 'ProcessExceptionStatus list is empty');
        System.assert(!processExceptionTypeList.isEmpty(), 'ProcessExceptionType list is empty');
        System.assert(!returnOrderStatusList.isEmpty(), 'ReturnOrderStatus list is empty');
        System.assert(!shipmentStatusList.isEmpty(), 'ShipmentStatus list is empty');
        System.assert(!locationTypeList.isEmpty(), 'LocationType list is empty');
        System.assert(String.isNotBlank(fulfillmentOrderStatusList[0].toString()), 'Enum value is empty');
    }
}