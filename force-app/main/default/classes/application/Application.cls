/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 31/07/2021
* @description Handles application-specific functionality
*/
public with sharing class Application {
    /**
    * @descripton Service register
    *   suppress reason: ignore
    */
    @suppressWarnings('PMD.FieldNamingConventions')
    public static final ServiceFactory Service = new ServiceFactory(
        new Map<Type, Type>
        {
            IOrderSummaryService.class => OrderSummaryService.class
        }
    );

    /**
    * @descripton Selector register
    *   suppress reason: ignore
    */
    @suppressWarnings('PMD.FieldNamingConventions')
    public static final SelectorFactory Selector = new SelectorFactory(
        new Map<SObjectType, Type>
        {
            FulfillmentOrder.SObjectType => FulfillmentOrderSelector.class
        }
    );

    /**
    * @descripton Service register
    *   suppress reason: ignore
    */
    @suppressWarnings('PMD.FieldNamingConventions')
    public static final ServiceFactory ConnectApi = new ServiceFactory(
        new Map<Type, Type>
        {
            IFulfillmentOrderApi.class => FulfillmentOrderApi.class,
            IOmnichannelInventoryServiceApi.class => OmnichannelInventoryServiceApi.class,
            IOrderPaymentSummaryApi.class => OrderPaymentSummaryApi.class,
            IOrderSummaryApi.class => OrderSummaryApi.class,
            IReturnOrderApi.class => ReturnOrderApi.class,
            IRoutingApi.class => RoutingApi.class
        }
    );
}