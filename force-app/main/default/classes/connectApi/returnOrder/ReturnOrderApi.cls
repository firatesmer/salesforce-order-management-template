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

    /**
    * @description Process ReturnOrderLineItems 
    *   belonging to a ReturnOrder. Processing 
    *   a ReturnOrderLineItem generates a change
    *   Order and makes that ReturnOrderLineItem
    *   read-only. If a processed ReturnOrderLineItem
    *   has any remaining expected quantity, then the
    *   API creates a separate ReturnOrderLineItem
    *   representing that quantity
    * @param returnOrderId Id of the Return
    * @return Return items output
    */
    // public static void returnItems(String returnOrderId) {

    // }
}