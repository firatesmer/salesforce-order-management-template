/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 14/07/2021
* @description ReturnOrder Api class
*/
public with sharing class ReturnOrderApi extends BaseApi {
    /**
    * @description Create a ReturnOrder and 
    *   ReturnOrderLineItems for items belonging
    *   to an OrderSummary
    * @param orderSummaryId Id of the OrderSummary
    * @param returnOrderStatus ReturnOrder status (enum)
    * @param returnOrderLineItemInputList ReturnOrderLineItemInput list
    * @return Create return order output
    */
    public ConnectApi.ReturnOrderOutputRepresentation createReturnOrder(String orderSummaryId, ReturnOrderStatus returnOrderStatus, List<ConnectApi.ReturnOrderLineItemInputRepresentation> returnOrderLineItemInputList) {
        ConnectApi.ReturnOrderInputRepresentation input = new ConnectApi.ReturnOrderInputRepresentation();
        input.orderSummaryId = orderSummaryId;
        input.returnOrderLifeCycleType = LifeCycleType.MANAGED.enumValue;
        input.returnOrderLineItems = returnOrderLineItemInputList;
        input.status = returnOrderStatus.enumValue;

        ConnectApi.ReturnOrderOutputRepresentation output = ConnectApi.ReturnOrder.createReturnOrder(input);
        super.insertFailedResults(output);
        return output;
    }
}