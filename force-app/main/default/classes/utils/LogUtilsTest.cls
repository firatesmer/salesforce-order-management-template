/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 23/01/2021
* @description Log utils test class
*/
@isTest
private class LogUtilsTest {
    /**
    * @description Test method of LogUtils.createErrorLog
    */
    @isTest
    static void shouldLogErrorWithAttachId() {
        String lastName = 'Doe';
        String category = 'Unit Test';
        String message = 'Unit test error';

        Contact contactToInsert = new Contact(Lastname=lastName);
        insert contactToInsert;

        String attachId = contactToInsert.Id;

        System.Test.startTest();
        OmsLog__c logToInsert = LogUtils.createErrorLog(attachId, category, message);
        insert logToInsert;
        System.Test.stopTest();

        OmsLog__c log = [SELECT AttachedToId__c, Category__c, Message__c, IsError__c FROM OmsLog__c WHERE Id =: logToInsert.Id];

        System.assert(log.AttachedToId__c.equals(attachId), 'Attached to Id doesn\'t match');
        System.assert(log.Category__c.equalsIgnoreCase(category), 'Category of the log doesn\'t match');
        System.assert(log.Message__c.equalsIgnoreCase(message), 'Message of the log doesn\'t match');
        System.assert(log.IsError__c, 'IsError should be checked/true');
    }

    /**
    * @description Test method of LogUtils.createErrorLog
    */
    @isTest
    static void shouldLogError() {
        String category = 'Unit Test';
        String message = 'Unit test error';

        System.Test.startTest();
        OmsLog__c logToInsert = LogUtils.createErrorLog(category, message);
        insert logToInsert;
        System.Test.stopTest();

        OmsLog__c log = [SELECT AttachedToId__c, Category__c, Message__c, IsError__c FROM OmsLog__c WHERE Id =: logToInsert.Id];

        System.assert(log.Category__c.equalsIgnoreCase(category), 'Category of the log doesn\'t match');
        System.assert(log.Message__c.equalsIgnoreCase(message), 'Message of the log doesn\'t match');
        System.assert(log.IsError__c, 'IsError should be checked/true');
    }

    /**
    * @description Test method of LogUtils.createInfoLog
    */
    @isTest
    static void shouldLogInfoWithAttachId() {
        String lastName = 'Doe';
        String category = 'Unit Test';
        String message = 'Unit test error';

        Contact contactToInsert = new Contact(Lastname=lastName);
        insert contactToInsert;

        String attachId = contactToInsert.Id;

        System.Test.startTest();
        OmsLog__c logToInsert = LogUtils.createInfoLog(attachId, category, message);
        insert logToInsert;
        System.Test.stopTest();

        OmsLog__c log = [SELECT AttachedToId__c, Category__c, Message__c, IsError__c FROM OmsLog__c WHERE Id =: logToInsert.Id];

        System.assert(log.AttachedToId__c.equals(attachId), 'Attached to Id doesn\'t match');
        System.assert(log.Category__c.equalsIgnoreCase(category), 'Category of the log doesn\'t match');
        System.assert(log.Message__c.equalsIgnoreCase(message), 'Message of the log doesn\'t match');
        System.assert(!log.IsError__c, 'IsError should be unchecked/false');
    }

    /**
    * @description Test method of LogUtils.createInfoLog
    */
    @isTest
    static void shouldLogInfo() {
        String category = 'Unit Test';
        String message = 'Unit test error';

        System.Test.startTest();
        OmsLog__c logToInsert = LogUtils.createInfoLog(category, message);
        insert logToInsert;
        System.Test.stopTest();

        OmsLog__c log = [SELECT AttachedToId__c, Category__c, Message__c, IsError__c FROM OmsLog__c WHERE Id =: logToInsert.Id];

        System.assert(log.Category__c.equalsIgnoreCase(category), 'Category of the log doesn\'t match');
        System.assert(log.Message__c.equalsIgnoreCase(message), 'Message of the log doesn\'t match');
        System.assert(!log.IsError__c, 'IsError should be unchecked/false');
    }
}