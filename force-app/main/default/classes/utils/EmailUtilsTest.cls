/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description Email utils test class
*/
@isTest
private class EmailUtilsTest {
    /**
     * @description Test method of EmailUtils.sendEmail (positive)
     */
    @isTest
    static void shouldSendEmail() {
        Messaging.EmailFileAttachment emailAttachment = new Messaging.EmailFileAttachment();
        emailAttachment.body = Blob.valueOf('Test');
        emailAttachment.filename = 'Test.txt';

        Test.startTest();
        Messaging.SendEmailResult[] results = EmailUtils.sendEmail(new List<String>{ 'firat.esmer@osf.digital' }, 'Test', 'Text', new Messaging.EmailFileAttachment[] { emailAttachment }, false);
        Test.stopTest();

        List<OmsLog__c> logs = [SELECT Id FROM OmsLog__c];

        System.assert(logs.isEmpty(), 'There should be no log(s)');
        System.assert(results[0].isSuccess(), 'Send email action is failed');
    }

    /**
     * @description Test method of EmailUtils.sendEmail (negative)
     */
    @isTest
    static void shouldNotSendEmail() {
        Test.startTest();
        Messaging.SendEmailResult[] results = EmailUtils.sendEmail(null, 'Test', 'Text', null, true);
        Test.stopTest();

        List<OmsLog__c> logs = [SELECT Id FROM OmsLog__c];

        System.assert(!logs.isEmpty(), 'There should be log(s)');
        System.assert(!results[0].isSuccess(), 'Send email action should fail');
    }
}