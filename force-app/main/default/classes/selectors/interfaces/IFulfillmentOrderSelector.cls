/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 31/07/2021
* @description FulfillmentOrder selector interface
*/
public interface IFulfillmentOrderSelector extends ISObjectSelector {
    /**
    * @description Selects FulfillmentOrder records based on the Id list
    * @param fulfillmentOrderIds List of the Ids
    * @return List of FulfillmentOrder
    */
    List<FulfillmentOrder> selectById(List<String> fulfillmentOrderIds);
}
