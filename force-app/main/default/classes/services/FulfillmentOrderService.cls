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
    * @return CreateFulfillmentOrderInput model
    */
    public static FulfillmentOrderApi.CreateFulfillmentOrderInput buildCreateFulfillmentOrderInput(String orderSummaryId, String locationId, String fulfillmentType) {
        FulfillmentOrderApi.CreateFulfillmentOrderInput createFulfillmentOrderInput = new FulfillmentOrderApi.CreateFulfillmentOrderInput();
        CreateFulfillmentOrderInput.fulfillmentType = fulfillmentType;
        CreateFulfillmentOrderInput.locationId = locationId;
        CreateFulfillmentOrderInput.orderSummaryId = orderSummaryId;
        return CreateFulfillmentOrderInput;
    }
}