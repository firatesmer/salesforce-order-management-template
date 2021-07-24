/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 24/07/2021
* @description ConnectApiBase test class
*/
@isTest
private class ConnectApiBaseTest {
    /**
    * @description Test method of 
    *   ConnectApiBase.insertFailedResults
    */
    @isTest
    static void shouldInsertFailedResults() {
        ConnectApi.FulfillmentOrderOutputRepresentation output = TestDataFactory.getDefaultFailFulfillmentOrderOutput();

        Test.startTest();
        new FulfillmentOrderApi().insertFailedResults(output);
        Test.stopTest();

        // Log with category 001 is created in TestDataFactory
        List<OmsLog__c> logs = [SELECT Id FROM OmsLog__c WHERE Category__c = '001'];

        System.assert(!logs.isEmpty(), 'No log records found');
    }
}