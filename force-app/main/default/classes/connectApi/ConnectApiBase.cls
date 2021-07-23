/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description Base class for Connect Api classes
*/
public without sharing abstract class ConnectApiBase {
    /**
    * @description Inserts failed results of ConnectApi methods
    * @param output Base output class
    */
    public virtual void insertFailedResults(ConnectApi.BaseOutputRepresentation output) {
        if (!output.success) {
            List<OmsLog__c> errorLogs = getResultErrors(output.errors);

            if (!errorLogs.isEmpty()) {
                Database.insert(errorLogs, false);
            }
        }
    }

    /**
    * @description Gets errors from result and creates a list with error logs
    * @param errors Errors
    * @return Error logs
    */
    private List<OmsLog__c> getResultErrors(ConnectApi.ErrorResponse[] errors) {
        List<OmsLog__c> errorLogs = new List<OmsLog__c>();

        for (ConnectApi.ErrorResponse error : errors) {
            OmsLog__c log = LogUtils.createErrorLog(error.errorCode, error.message);
            errorLogs.add(log);
        }

        return errorLogs;
    }
}