/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 31/07/2021
* @description FulfillmentOrder selector class
*/
public with sharing class FulfillmentOrderSelector implements IFulfillmentOrderSelector {
    private final static Schema.SObjectType OBJECT_TYPE = FulfillmentOrder.SObjectType;

    /**
    * @description Gets instance of concrete implementation
    *   of IFulfillmentOrderSelector interface
    * @return Instance of IFulfillmentOrderSelector implementation
    */
    public IFulfillmentOrderSelector newInstance() {
        return (IFulfillmentOrderSelector)Application.Selector.newInstance(OBJECT_TYPE);
    }

    /**
    * @description Gets the SObjectType of FulfillmentOrder object
    * @return SObjectType of FulfillmentOrder object
    */    
    public Schema.SObjectType getSObjectType() {
        return OBJECT_TYPE;
    }

    /**
    * @description Selects FulfillmentOrder records based on the Id list
    * @param fulfillmentOrderIds List of the Ids
    * @return List of FulfillmentOrder
    */
    public List<FulfillmentOrder> selectById(List<String> fulfillmentOrderIds) {
        return [SELECT Id 
                FROM FulfillmentOrder 
                WHERE Id IN: fulfillmentOrderIds
                WITH SECURITY_ENFORCED];
    }
}