/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description Test class of callout utils class
*/
@isTest
private class CalloutUtilsTest {
    /**
    * @description Test method of CalloutUtils.doCallout (positive)
    */
    @isTest
    static void shouldSuccessCallout() {
        Test.setMock(HttpCalloutMock.class, new RestSuccessMock());

        Map<String, String> headers = new Map<String, String>{ 'accept' => 'application/json' };

        Test.startTest();
        HttpResponse response = CalloutUtils.doCallout('.com/api/orders', Constants.POST, headers, '{ "go": true }', Enums.LogLevel.ALL, false);
        CalloutUtils.insertHttpLogs();
        Test.stopTest();

        List<OmsLog__c> logs = [SELECT Id FROM OmsLog__c];

        System.assert(response.getStatusCode() == 200, 'Http status code of the response should 200 OK');
        System.assert(logs.size() == 2, 'There should be 2 (request/response) logs');
    }

    /**
    * @description Test method of CalloutUtils.doCallout (negative)
    */
    @isTest
    static void shouldFailCallout() {
        Test.setMock(HttpCalloutMock.class, new RestFailMock());

        Map<String, String> headers = new Map<String, String>{ 'accept' => 'application/json' };

        Test.startTest();
        HttpResponse response = CalloutUtils.doCallout('.com/api/orders', Constants.POST, headers, '{ "go": true }');
        CalloutUtils.insertHttpLogs();
        Test.stopTest();

        List<OmsLog__c> logs = [SELECT Id FROM OmsLog__c];

        System.assert(response.getStatusCode() == 500, 'Http status code of the response should 200 OK');
        System.assert(logs.size() == 2, 'There should be 2 (request/response) logs');
    }

    /**
    * @description Test method of CalloutUtils.doCallout (without logs)
    */
    @isTest
    static void shouldSuccessCalloutWithoutLogs() {
        Test.setMock(HttpCalloutMock.class, new RestSuccessMock());

        Map<String, String> headers = new Map<String, String>{ 'accept' => 'application/json' };

        Test.startTest();
        HttpResponse response = CalloutUtils.doCallout('.com/api/orders', Constants.POST, headers, '{ "go": true }', Enums.LogLevel.NONE, false);
        Test.stopTest();

        List<OmsLog__c> logs = [SELECT Id FROM OmsLog__c];

        System.assert(response.getStatusCode() == 200, 'Http status code of the response should 200 OK');
        System.assert(logs.size() == 0, 'There should be no (request/response) logs');
    }
}