/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 23/05/2021
* @description Object utils class
*/
public with sharing class ObjectUtils {
    /**
    * @description Gets Id list from SObject list
    * @param sObjectList Object list
    * @return Id list 
    */
    public static Set<String> getIdList(List<SObject> sObjectList) {
        Set<String> idList = new Set<String>();

        for (SObject obj : sObjectList) {
            idList.add(String.valueOf(obj.get(Constants.ID)));
        }

        return idList;
    }
}