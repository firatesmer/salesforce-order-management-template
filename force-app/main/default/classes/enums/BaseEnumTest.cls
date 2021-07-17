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
    *   suppress reason: ignore
    */
    @isTest
    @suppressWarnings('PMD.NcssMethodCount')
    static void shouldInitiateEnums() {
        List<CardPaymentMethodCategory> cardPaymentMethodCategoryList = CardPaymentMethodCategory.values();
        List<CardPaymentMethodStatus> cardPaymentMethodStatusList = CardPaymentMethodStatus.values();
        List<CardPaymentMethodType> cardPaymentMethodTypeList = CardPaymentMethodType.values();
        List<FulfillmentOrderStatus> fulfillmentOrderStatusList = FulfillmentOrderStatus.values();
        List<FulfillmentOrderType> fulfillmentOrderTypeList = FulfillmentOrderType.values();
        List<InvoiceStatus> invoiceStatusList = InvoiceStatus.values();
        List<LifeCycleType> lifeCycleTypeList = LifeCycleType.values();
        List<LocationType> locationTypeList = LocationType.values();
        List<OrderItemStatus> OrderItemStatusList = OrderItemStatus.values();
        List<OrderItemSummaryChangeReason> OrderItemSummaryChangeList = OrderItemSummaryChangeReason.values();
        List<OrderItemType> OrderItemTypeList = OrderItemType.values();
        List<OrderStatus> orderStatusList = OrderStatus.values();
        List<OrderSummaryStatus> orderSummaryStatusList = OrderSummaryStatus.values();
        List<PaymentAuthorizationStatus> paymentAuthorizationStatusList = PaymentAuthorizationStatus.values();
        List<PaymentStatus> paymentStatusList = PaymentStatus.values();
        List<PaymentType> paymentTypeList = PaymentType.values();
        List<ProcessExceptionStatus> processExceptionStatusList = ProcessExceptionStatus.values();
        List<ProcessExceptionType> processExceptionTypeList = ProcessExceptionType.values();
        List<ProcessingMode> processingModeList = ProcessingMode.values();
        List<ReturnOrderLineItemReturnReason> returnOrderLineItemReturnReasonList = ReturnOrderLineItemReturnReason.values();
        List<ReturnOrderStatus> returnOrderStatusList = ReturnOrderStatus.values();
        List<ShipmentStatus> shipmentStatusList = ShipmentStatus.values();

        System.assert(!cardPaymentMethodCategoryList.isEmpty(), 'CardPaymentMethodCategory list is empty');
        System.assert(!cardPaymentMethodStatusList.isEmpty(), 'CardPaymentMethodStatus list is empty');
        System.assert(!cardPaymentMethodTypeList.isEmpty(), 'CardPaymentMethodType list is empty');
        System.assert(!fulfillmentOrderStatusList.isEmpty(), 'FulfillmentOrderStatus list is empty');
        System.assert(!fulfillmentOrderTypeList.isEmpty(), 'FulfillmentOrderType list is empty');
        System.assert(!invoiceStatusList.isEmpty(), 'InvoiceStatus list is empty');
        System.assert(!OrderItemStatusList.isEmpty(), 'OrderItemStatus list is empty');
        System.assert(!OrderItemSummaryChangeList.isEmpty(), 'OrderItemSummaryChangeReason list is empty');
        System.assert(!OrderItemTypeList.isEmpty(), 'OrderItemType list is empty');
        System.assert(!orderStatusList.isEmpty(), 'OrderStatus list is empty');
        System.assert(!orderSummaryStatusList.isEmpty(), 'OrderSummaryStatus list is empty');
        System.assert(!paymentAuthorizationStatusList.isEmpty(), 'PaymentAuthorizationStatus list is empty');
        System.assert(!paymentStatusList.isEmpty(), 'PaymentStatus list is empty');
        System.assert(!paymentTypeList.isEmpty(), 'PaymentType list is empty');
        System.assert(!processExceptionStatusList.isEmpty(), 'ProcessExceptionStatus list is empty');
        System.assert(!processExceptionTypeList.isEmpty(), 'ProcessExceptionType list is empty');
        System.assert(!processingModeList.isEmpty(), 'ProcessingMode list is empty');
        System.assert(!returnOrderLineItemReturnReasonList.isEmpty(), 'ReturnOrderLineItemReturnReason list is empty');
        System.assert(!returnOrderStatusList.isEmpty(), 'ReturnOrderStatus list is empty');
        System.assert(!shipmentStatusList.isEmpty(), 'ShipmentStatus list is empty');
        System.assert(!lifeCycleTypeList.isEmpty(), 'LifeCycleType list is empty');
        System.assert(!locationTypeList.isEmpty(), 'LocationType list is empty');
        System.assert(String.isNotBlank(fulfillmentOrderStatusList[0].enumKey), 'Enum key is empty');
        System.assert(String.isNotBlank(fulfillmentOrderStatusList[0].enumValue), 'Enum value is empty');
        System.assert(String.isNotBlank(fulfillmentOrderStatusList[0].toString()), 'Enum ToString method output is empty');
    }
}