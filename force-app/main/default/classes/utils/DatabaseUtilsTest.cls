/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 23/01/2021
* @description Database utils test class
*/
@isTest
private class DatabaseUtilsTest {
    /**
    * @description Test method of DatabaseUtils.insertRecords
    */
    @isTest
    static void shouldInsertRecords() {
        Contact[] contacts = new List<Contact>
        {
            TestDataFactory.createContact('Doe'),
            TestDataFactory.createContact('Brown')
        };

        System.Test.startTest();
        DatabaseUtils.insertRecords(contacts, false);
        System.Test.stopTest();

        List<OmsLog__c> logs = [SELECT Id FROM OmsLog__c];

        System.assert(logs.isEmpty(), 'Error logs found');
    }

    /**
    * @description Test method of DatabaseUtils.insertRecords
    */
    @isTest
    static void shouldNotInsertRecords() {
        Contact[] contacts = new List<Contact>
        {
            TestDataFactory.createContact('Doe'),
            TestDataFactory.createContact(null)
        };

        System.Test.startTest();
        DatabaseUtils.insertRecords(contacts, false);
        System.Test.stopTest();

        List<OmsLog__c> logs = [SELECT Id FROM OmsLog__c];

        System.assert(!logs.isEmpty(), 'Error log couldn\'t found');
    }

    /**
    * @description Test method of DatabaseUtils.updateRecords
    */
    @isTest
    static void shouldUpdateRecords() {
        String firstName = 'John';

        Contact contact = TestDataFactory.createContact('Doe');
        insert contact;

        contact.FirstName = firstName;

        System.Test.startTest();
        DatabaseUtils.updateRecords(new List<Contact>{ contact }, false);
        System.Test.stopTest();

        List<OmsLog__c> logs = [SELECT Id FROM OmsLog__c];

        System.assert(logs.isEmpty(), 'Error logs found');
        System.assert(contact.FirstName.equalsIgnoreCase(firstName), 'Record is not updated');
    }

    /**
    * @description Test method of DatabaseUtils.updateRecords
    */
    @isTest
    static void shouldNotUpdateRecords() {
        String lastName = 'Doe';

        Contact contactToUpdate = TestDataFactory.createContact(lastName);
        insert contactToUpdate;

        contactToUpdate.LastName = '';

        System.Test.startTest();
        DatabaseUtils.insertRecords(new List<Contact>{ contactToUpdate }, false);
        System.Test.stopTest();

        List<OmsLog__c> logs = [SELECT Id FROM OmsLog__c];
        Contact updatedContact = [SELECT LastName FROM Contact WHERE Id =: contactToUpdate.Id];

        System.assert(!logs.isEmpty(), 'Error log couldn\'t found');
        System.assert(updatedContact.LastName.equalsIgnoreCase(lastName), 'Record is updated');
    }

    /**
    * @description Test method of DatabaseUtils.upsertRecords
    */
    @isTest
    static void shouldUpsertRecords() {
        String firstName = 'John';

        Contact contact = TestDataFactory.createContact('Doe');
        insert contact;

        contact.FirstName = firstName;

        System.Test.startTest();
        DatabaseUtils.upsertRecords(new List<Contact>{ contact }, false);
        System.Test.stopTest();

        List<OmsLog__c> logs = [SELECT Id FROM OmsLog__c];

        System.assert(logs.isEmpty(), 'Error logs found');
        System.assert(contact.FirstName.equalsIgnoreCase(firstName), 'Record is not updated');
    }

    /**
    * @description Test method of DatabaseUtils.upsertRecords
    */
    @isTest
    static void shouldNotUpsertRecords() {
        String lastName = 'Doe';

        Contact contactToUpdate = TestDataFactory.createContact(lastName);
        insert contactToUpdate;

        contactToUpdate.LastName = '';

        System.Test.startTest();
        DatabaseUtils.upsertRecords(new List<Contact>{ contactToUpdate }, false);
        System.Test.stopTest();

        List<OmsLog__c> logs = [SELECT Id FROM OmsLog__c];
        Contact updatedContact = [SELECT LastName FROM Contact WHERE Id =: contactToUpdate.Id];

        System.assert(!logs.isEmpty(), 'Error log couldn\'t found');
        System.assert(updatedContact.LastName.equalsIgnoreCase(lastName), 'Record is updated');
    }

    /**
    * @description Test method of DatabaseUtils.deleteRecords
    */
    @isTest
    static void shouldDeleteRecords() {
        Contact contact = TestDataFactory.createContact('Doe');
        insert contact;

        System.Test.startTest();
        DatabaseUtils.deleteRecords(new List<String>{ contact.Id }, false);
        System.Test.stopTest();

        List<OmsLog__c> logs = [SELECT Id FROM OmsLog__c];
        List<Contact> contacts = [SELECT Id FROM Contact WHERE Id =: contact.Id];

        System.assert(logs.isEmpty(), 'Error logs found');
        System.assert(contacts.isEmpty(), 'Records are not deleted');
    }

    /**
    * @description Test method of DatabaseUtils.deleteRecords
    */
    @isTest
    static void shouldNotDeleteRecords() {
        Contact contact = TestDataFactory.createContact('Doe');
        insert contact;
        delete contact;

        System.Test.startTest();
        DatabaseUtils.deleteRecords(new List<String>{ contact.Id }, false);
        System.Test.stopTest();

        List<OmsLog__c> logs = [SELECT Id FROM OmsLog__c];

        System.assert(!logs.isEmpty(), 'Error log couldn\'t found');
    }

    /**
    * @description Test method of DatabaseUtils.undeleteRecords
    */
    @isTest
    static void shouldUndeleteRecords() {
        Contact contact = TestDataFactory.createContact('Doe');
        insert contact;
        delete contact;

        System.Test.startTest();
        DatabaseUtils.undeleteRecords(new List<String>{ contact.Id }, false);
        System.Test.stopTest();

        List<OmsLog__c> logs = [SELECT Id FROM OmsLog__c];
        List<Contact> contacts = [SELECT Id FROM Contact WHERE Id =: contact.Id];

        System.assert(logs.isEmpty(), 'Error logs found');
        System.assert(!contacts.isEmpty(), 'Records are not undeleted');
    }

    /**
    * @description Test method of DatabaseUtils.undeleteRecords
    */
    @isTest
    static void shouldNotUndeleteRecords() {
        Contact contact = TestDataFactory.createContact('Doe');
        insert contact;

        System.Test.startTest();
        DatabaseUtils.undeleteRecords(new List<String>{ contact.Id }, false);
        System.Test.stopTest();

        List<OmsLog__c> logs = [SELECT Id FROM OmsLog__c];

        System.assert(!logs.isEmpty(), 'Error log couldn\'t found');
    }
}