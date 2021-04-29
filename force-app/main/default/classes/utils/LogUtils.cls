/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 23/01/2021
* @description Log utils class
*/
public with sharing class LogUtils {
    /**
    * @description Creates Oms log object
    * @param attachedToId Attached/related object Id
    * @param category Category of the log
    * @param message Message of the log
    * @return OmsLog__c instance
    */
    public static OmsLog__c createErrorLog(String attachedToId, String category, String message) {
        OmsLog__c log = new OmsLog__c();
        log.AttachedToId__c = attachedToId;
        log.Category__c = category;
        log.Message__c = message;
        log.IsError__c = true;
        return log;
    }

    /**
    * @description Creates Oms log object
    * @param category Category of the log
    * @param message Message of the log
    * @return OmsLog__c instance
    */
    public static OmsLog__c createErrorLog(String category, String message) {
        OmsLog__c log = new OmsLog__c();
        log.Category__c = category;
        log.Message__c = message;
        log.IsError__c = true;
        return log;
    }

    /**
    * @description Creates Oms log object
    * @param attachedToId Attached/related object Id
    * @param category Category of the log
    * @param message Message of the log
    * @return OmsLog__c instance
    */
    public static OmsLog__c createInfoLog(String attachedToId, String category, String message) {
        OmsLog__c log = new OmsLog__c();
        log.AttachedToId__c = attachedToId;
        log.Category__c = category;
        log.Message__c = message;
        return log;
    }

    /**
    * @description Creates Oms log object
    * @param category Category of the log
    * @param message Message of the log
    * @return OmsLog__c instance
    */
    public static OmsLog__c createInfoLog(String category, String message) {
        OmsLog__c log = new OmsLog__c();
        log.Category__c = category;
        log.Message__c = message;
        return log;
    }
}