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
        List<FulfillmentOrderStatus> fulfillmentOrderStatusList = FulfillmentOrderStatus.values();
        List<InvoiceStatus> invoiceStatusList = InvoiceStatus.values();
        List<OrderSummaryStatus> orderSummaryStatusList = OrderSummaryStatus.values();
        List<ProcessExceptionStatus> processExceptionStatusList = ProcessExceptionStatus.values();
        List<ReturnOrderStatus> returnOrderStatusList = ReturnOrderStatus.values();
        List<ShipmentStatus> shipmentStatusList = ShipmentStatus.values();
        List<CardPaymentMethodType> cardPaymentMethodTypeList = CardPaymentMethodType.values();
        List<FulfillmentOrderType> fulfillmentOrderTypeList = FulfillmentOrderType.values();
        List<LocationType> locationTypeList = LocationType.values();
        List<OrderProductType> orderProductTypeList = OrderProductType.values();
        List<ProcessExceptionType> processExceptionTypeList = ProcessExceptionType.values();

        System.assert(!cardPaymentMethodStatusList.isEmpty(), 'CardPaymentMethodStatus list is empty');
        System.assert(!fulfillmentOrderStatusList.isEmpty(), 'FulfillmentOrderStatus list is empty');
        System.assert(!invoiceStatusList.isEmpty(), 'InvoiceStatus list is empty');
        System.assert(!orderSummaryStatusList.isEmpty(), 'OrderSummaryStatus list is empty');
        System.assert(!processExceptionStatusList.isEmpty(), 'ProcessExceptionStatus list is empty');
        System.assert(!returnOrderStatusList.isEmpty(), 'ReturnOrderStatus list is empty');
        System.assert(!shipmentStatusList.isEmpty(), 'ShipmentStatus list is empty');
        System.assert(!cardPaymentMethodTypeList.isEmpty(), 'CardPaymentMethod list is empty');
        System.assert(!fulfillmentOrderTypeList.isEmpty(), 'FulfillmentOrderType list is empty');
        System.assert(!locationTypeList.isEmpty(), 'LocationType list is empty');
        System.assert(!orderProductTypeList.isEmpty(), 'OrderProductType list is empty');
        System.assert(!processExceptionTypeList.isEmpty(), 'ProcessExceptionType list is empty');
        System.assert(String.isNotBlank(fulfillmentOrderStatusList[0].toString()), 'Enum value is empty');
    }
}