/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/08/2021
* @description Email utils class
*/
public with sharing class EmailUtils {
    /**
    * @description Sends email
    * @param emailAddresses Email address list
    * @param subject Email subject
    * @param body Email body (plaint text or html)
    * @param attachments Attachments
    * @param isHtml Is email body HTML
    * @return Send email result list
    */
    @suppressWarnings('PMD.ExcessiveParameterList')
    public static Messaging.SendEmailResult[] sendEmail(String[] emailAddresses, String subject, String body, Messaging.EmailFileAttachment[] attachments, Boolean isHtml) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(emailAddresses);
        mail.setSubject(subject);

        if (isHtml) {
            mail.setHtmlBody(body);
        }
        else {
            mail.setPlainTextBody(body);
        }

        if (attachments != null && !attachments.isEmpty()) {
            mail.setFileAttachments(attachments);
        }

        Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }, false);
        insertFailedEmailResults(results);

        return results;
    }

    /**
    * @description Creates Oms log object based on failed send email result(s)
    * @param results Send email results
    */
    private static void insertFailedEmailResults(Messaging.SendEmailResult[] results) {
        if (!results.isEmpty()) {
            List<OmsLog__c> errorLogs = new List<OmsLog__c>();

            for (Messaging.SendEmailResult result : results) {
                if (!result.isSuccess()) {
                    errorLogs.addAll(getResultErrors(result.getErrors()));
                }
            }

            if (!errorLogs.isEmpty()) {
                DatabaseUtils.insertRecords(errorLogs, false);
            }
        }
    }

    /**
    * @description Gets errors from result and creates a list with error logs
    * @param errors Errors
    * @return Error logs
    */
    private static List<OmsLog__c> getResultErrors(Messaging.SendEmailError[] errors) {
        List<OmsLog__c> errorLogs = new List<OmsLog__c>();

        for (Database.Error error : errors) {
            OmsLog__c log = LogUtils.createErrorLog(String.valueOf(error.getStatusCode()), error.getMessage());
            errorLogs.add(log);
        }

        return errorLogs;
    }
}