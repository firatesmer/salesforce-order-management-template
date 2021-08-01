/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 31/07/2021
* @description SObject selector interface
*/
public interface ISObjectSelector {
    /**
    * @description Provides the SObjectType for the object
    *   the given Selector is providing query logic for
    * @return Type of the SObject
    */
    Schema.SObjectType getSObjectType();
}