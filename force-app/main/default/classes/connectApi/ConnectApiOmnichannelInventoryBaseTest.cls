/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 24/07/2021
* @description ConnectApiOmnichannelInventoryBase test class
*/
@isTest
private class ConnectApiOmnichannelInventoryBaseTest {
    /**
    * @description Test method of 
    *   ConnectApiOmnichannelInventoryBase.insertFailedResults
    */
    @isTest
    static void shouldInsertFailedResultsForBaseOutput() {
        ConnectApi.OCIGetInventoryAvailabilityOutputRepresentation output = OmnichannelInventoryTestDataFactory.getFailInventoryAvailabilityOutputRepresentation();

        Test.startTest();
        new OmnichannelInventoryServiceApi().insertFailedResults(output);
        Test.stopTest();

        // Log with category 001 is created in OmnichannelInventoryTestDataFactory
        List<OmsLog__c> logs = [SELECT Id FROM OmsLog__c WHERE Category__c = '001'];

        System.assert(!logs.isEmpty(), 'No log records found');
    }

    /**
    * @description Test method of 
    *   ConnectApiOmnichannelInventoryBase.insertFailedResults
    */
    @isTest
    static void shouldInsertFailedResultsForCreateReservationOutput() {
        ConnectApi.OCICreateReservationOutputRepresentation output = OmnichannelInventoryTestDataFactory.getFailCreateReservationOutput();

        Test.startTest();
        new OmnichannelInventoryServiceApi().insertFailedResults(output);
        Test.stopTest();

        // Log with category 001 is created in OmnichannelInventoryTestDataFactory
        List<OmsLog__c> logs = [SELECT Id FROM OmsLog__c WHERE Category__c = '001'];

        System.assert(!logs.isEmpty(), 'No log records found');
    }

    /**
    * @description Test method of 
    *   ConnectApiOmnichannelInventoryBase.insertFailedResults
    */
    @isTest
    static void shouldInsertFailedResultsForFulfillReservationOutput() {
        ConnectApi.OCIFulfillReservationOutputRepresentation output = OmnichannelInventoryTestDataFactory.getFailFulfillReservationOutput();

        Test.startTest();
        new OmnichannelInventoryServiceApi().insertFailedResults(output);
        Test.stopTest();

        // Log with category 001 is created in OmnichannelInventoryTestDataFactory
        List<OmsLog__c> logs = [SELECT Id FROM OmsLog__c WHERE Category__c = '001'];

        System.assert(!logs.isEmpty(), 'No log records found');
    }

    /**
    * @description Test method of 
    *   ConnectApiOmnichannelInventoryBase.insertFailedResults
    */
    @isTest
    static void shouldInsertFailedResultsForReleaseReservationOutput() {
        ConnectApi.OCIReleaseReservationOutputRepresentation output = OmnichannelInventoryTestDataFactory.getFailReleaseReservationOutput();

        Test.startTest();
        new OmnichannelInventoryServiceApi().insertFailedResults(output);
        Test.stopTest();

        // Log with category 001 is created in OmnichannelInventoryTestDataFactory
        List<OmsLog__c> logs = [SELECT Id FROM OmsLog__c WHERE Category__c = '001'];

        System.assert(!logs.isEmpty(), 'No log records found');
    }

    /**
    * @description Test method of 
    *   ConnectApiOmnichannelInventoryBase.insertFailedResults
    */
    @isTest
    static void shouldInsertFailedResultsForFailTransferReservationOutput() {
        ConnectApi.OCITransferReservationOutputRepresentation output = OmnichannelInventoryTestDataFactory.getFailTransferReservationOutput();

        Test.startTest();
        new OmnichannelInventoryServiceApi().insertFailedResults(output);
        Test.stopTest();

        // Log with category 001 is created in OmnichannelInventoryTestDataFactory
        List<OmsLog__c> logs = [SELECT Id FROM OmsLog__c WHERE Category__c = '001'];

        System.assert(!logs.isEmpty(), 'No log records found');
    }
}