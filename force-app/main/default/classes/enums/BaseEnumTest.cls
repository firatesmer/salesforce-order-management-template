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
        List<FulfillmentOrderStatus> fulfillmentOrderStatusList = FulfillmentOrderStatus.values();
        List<InvoiceStatus> invoiceStatusList = InvoiceStatus.values();
        List<OrderSummaryStatus> orderSummaryStatusList = OrderSummaryStatus.values();
        List<ProcessExceptionStatus> processExceptionStatusList = ProcessExceptionStatus.values();
        List<ReturnOrderStatus> returnOrderStatusList = ReturnOrderStatus.values();
        List<ShipmentStatus> shipmentStatusList = ShipmentStatus.values();
        List<FulfillmentOrderType> fulfillmentOrderTypeList = FulfillmentOrderType.values();
        List<LocationType> locationTypeList = LocationType.values();
        List<OrderProductType> orderProductTypeList = OrderProductType.values();
        List<ProcessExceptionType> processExceptionTypeList = ProcessExceptionType.values();

        System.assert(!fulfillmentOrderStatusList.isEmpty(), 'Fulfillment order status list is empty');
        System.assert(!invoiceStatusList.isEmpty(), 'Invoice status list is empty');
        System.assert(!orderSummaryStatusList.isEmpty(), 'Order summary status list is empty');
        System.assert(!processExceptionStatusList.isEmpty(), 'Process exception status list is empty');
        System.assert(!returnOrderStatusList.isEmpty(), 'Return order status list is empty');
        System.assert(!shipmentStatusList.isEmpty(), 'Shipment status list is empty');
        System.assert(!fulfillmentOrderTypeList.isEmpty(), 'Fulfillment order type list is empty');
        System.assert(!locationTypeList.isEmpty(), 'Location type list is empty');
        System.assert(!orderProductTypeList.isEmpty(), 'Order product type list is empty');
        System.assert(!processExceptionTypeList.isEmpty(), 'Process exception type list is empty');
        System.assert(String.isNotBlank(fulfillmentOrderStatusList[0].toString()), 'Enum value is empty');
    }
}