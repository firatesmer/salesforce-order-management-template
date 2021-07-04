/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description FulfillmentOrder/FulfillmentOrderLineItem service class
*/
public with sharing class FulfillmentOrderService {
    /**
    * @description Builds request for create FulfillmentOrder
    * @param orderSummaryId The Id of the OrderSummary
    * @param locationId The Id of the Location
    * @param fulfillmentType The type of the FulfillmentOrder
    * @return CreateFulfillmentOrder model
    */
    public static FulfillmentOrderApi.CreateFulfillmentOrder buildCreateFulfillmentOrderRequest(String orderSummaryId, String locationId, String fulfillmentType) {
        FulfillmentOrderApi.CreateFulfillmentOrder createFulfillmentOrder = new FulfillmentOrderApi.CreateFulfillmentOrder();
        createFulfillmentOrder.fulfillmentType = fulfillmentType;
        createFulfillmentOrder.locationId = locationId;
        createFulfillmentOrder.orderSummaryId = orderSummaryId;
        return createFulfillmentOrder;
    }
}