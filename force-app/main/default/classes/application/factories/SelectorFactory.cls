/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 31/07/2021
* @description Factory class for selectors
*/
public virtual class SelectorFactory {
    protected Map<SObjectType, Type> sObjectToSelectorTypeMap;

    /**
    * @description Constructor
    * @param sObjectToSelectorTypeMap Map of sObject to type of the selector
    */
    public SelectorFactory(Map<SObjectType, Type> sObjectToSelectorTypeMap) {
        this.sObjectToSelectorTypeMap = sObjectToSelectorTypeMap;
    }

    /**
    * @description Creates a new instance of selector by the type
    * @param sObjectType Type of the SObject
    * @return Selector instance
    */
    public virtual ISObjectSelector newInstance(SObjectType sObjectType) {
        // get the type of the sObject from the map passed into constructor
        Type selectorType = sObjectToSelectorTypeMap.get(sObjectType);

        if (selectorType == null) {
            throw new ApplicationException('Selector type not found for SObjectType ' + sObjectType);
        }

        return (ISObjectSelector)selectorType.newInstance();
    }
}