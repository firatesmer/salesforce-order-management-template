public without sharing abstract class ConnectApiOmnichannelInventoryBase {
    /**
    * @description Inserts failed results of OCI ConnectApi methods
    *   (base for some of them)
    * @param output OCIBaseOutputRepresentation
    */
    public virtual void insertFailedResults(ConnectApi.OCIBaseOutputRepresentation output) {
        if (!output.success) {
            List<OmsLog__c> errorLogs = getResultErrors(output.errors);

            if (!errorLogs.isEmpty()) {
                Database.insert(errorLogs, false);
            }
        }
    }

    /**
    * @description Inserts failed results of OCI ConnectApi methods
    * @param output OCICreateReservationOutputRepresentation
    */
    public virtual void insertFailedResults(ConnectApi.OCICreateReservationOutputRepresentation output) {
        if (!output.success) {
            List<OmsLog__c> errorLogs = getResultErrors(output.errors);

            if (!errorLogs.isEmpty()) {
                Database.insert(errorLogs, false);
            }
        }
    }

    /**
    * @description Inserts failed results of OCI ConnectApi methods
    * @param output OCIFulfillReservationOutputRepresentation
    */
    public virtual void insertFailedResults(ConnectApi.OCIFulfillReservationOutputRepresentation output) {
        if (!output.success) {
            List<OmsLog__c> errorLogs = getResultErrors(output.errors);

            if (!errorLogs.isEmpty()) {
                Database.insert(errorLogs, false);
            }
        }
    }

    /**
    * @description Inserts failed results of OCI ConnectApi methods
    * @param output OCIReleaseReservationOutputRepresentation
    */
    public virtual void insertFailedResults(ConnectApi.OCIReleaseReservationOutputRepresentation output) {
        if (!output.success) {
            List<OmsLog__c> errorLogs = getResultErrors(output.errors);

            if (!errorLogs.isEmpty()) {
                Database.insert(errorLogs, false);
            }
        }
    }

    /**
    * @description Inserts failed results of OCI ConnectApi methods
    * @param output OCIReleaseReservationOutputRepresentation
    */
    public virtual void insertFailedResults(ConnectApi.OCITransferReservationOutputRepresentation output) {
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
    private List<OmsLog__c> getResultErrors(ConnectApi.OCITransferReservationErrorOutputRepresentation[] errors) {
        List<OmsLog__c> errorLogs = new List<OmsLog__c>();

        for (ConnectApi.OCITransferReservationErrorOutputRepresentation error : errors) {
            OmsLog__c log = LogUtils.createErrorLog(error.errorCode, error.message);
            errorLogs.add(log);
        }

        return errorLogs;
    }

    /**
    * @description Gets errors from result and creates a list with error logs
    * @param errors Errors
    * @return Error logs
    */
    private List<OmsLog__c> getResultErrors(ConnectApi.OCIFulfillReservationErrorOutputRepresentation[] errors) {
        List<OmsLog__c> errorLogs = new List<OmsLog__c>();

        for (ConnectApi.OCIFulfillReservationErrorOutputRepresentation error : errors) {
            OmsLog__c log = LogUtils.createErrorLog(error.errorCode, error.message);
            errorLogs.add(log);
        }

        return errorLogs;
    }

    /**
    * @description Gets errors from result and creates a list with error logs
    * @param errors Errors
    * @return Error logs
    */
    private List<OmsLog__c> getResultErrors(ConnectApi.OCICreateReservationErrorOutputRepresentation[] errors) {
        List<OmsLog__c> errorLogs = new List<OmsLog__c>();

        for (ConnectApi.OCICreateReservationErrorOutputRepresentation error : errors) {
            OmsLog__c log = LogUtils.createErrorLog(error.errorCode, error.message);
            errorLogs.add(log);
        }

        return errorLogs;
    }

    /**
    * @description Gets errors from result and creates a list with error logs
    * @param errors Errors
    * @return Error logs
    */
    private List<OmsLog__c> getResultErrors(ConnectApi.OCIReleaseReservationErrorOutputRepresentation[] errors) {
        List<OmsLog__c> errorLogs = new List<OmsLog__c>();

        for (ConnectApi.OCIReleaseReservationErrorOutputRepresentation error : errors) {
            OmsLog__c log = LogUtils.createErrorLog(error.errorCode, error.message);
            errorLogs.add(log);
        }

        return errorLogs;
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