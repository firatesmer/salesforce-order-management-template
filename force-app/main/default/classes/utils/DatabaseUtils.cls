/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 23/01/2021
* @description Database utils class
*/
public with sharing class DatabaseUtils {
    /**
    * @description Inserts records
    * @param records Records to be inserted
    * @param allOrNone Insert all or none
    * @return Inserted records
    */
    public static List<sObject> insertRecords(List<sObject> records, Boolean allOrNone) {
        Database.SaveResult[] results = Database.insert(records, allOrNone);
        insertFailedResults(results);

        return records;
    }

    /**
    * @description Updates records
    * @param records Records to be updated
    * @param allOrNone Update all or none
    * @return Updated records
    */
    public static List<sObject> updateRecords(List<sObject> records, Boolean allOrNone) {
        Database.SaveResult[] results = Database.update(records, allOrNone);
        insertFailedResults(results);

        return records;
    }

    /**
    * @description Upserts records
    * @param records Records to be upserted
    * @param allOrNone Upsert all or none
    * @return Upserted records
    */
    public static List<sObject> upsertRecords(List<sObject> records, Boolean allOrNone) {
        Database.UpsertResult[] results = Database.upsert(records, allOrNone);
        insertFailedResults(results);

        return records;
    }

    /**
    * @description Deletes records
    * @param recordIds Ids of the records to be deleted
    * @param allOrNone Delete all or none
    * @return Deleted record ids
    */
    public static List<String> deleteRecords(List<String> recordIds, Boolean allOrNone) {
        Database.DeleteResult[] results = Database.delete(recordIds, allOrNone);
        insertFailedResults(results);

        return recordIds;
    }

    /**
    * @description Undeletes records
    * @param recordIds Ids of the records to be deleted
    * @param allOrNone Undelete all or none
    * @return Undeleted record ids
    */
    public static List<String> undeleteRecords(List<String> recordIds, Boolean allOrNone) {
        Database.UndeleteResult[] results = Database.undelete(recordIds, allOrNone);
        insertFailedResults(results);

        return recordIds;
    }

    /**
    * @description Creates Oms log object based on failed save result(s)
    * @param results Save result list
    */
    private static void insertFailedResults(Database.SaveResult[] results) {
        if (!results.isEmpty()) {
            List<OmsLog__c> errorLogs = new List<OmsLog__c>();

            for (Database.SaveResult result : results) {
                if (!result.isSuccess()) {
                    errorLogs.addAll(getResultErrors(result.getErrors()));
                }
            }

            if (!errorLogs.isEmpty()) {
                Database.insert(errorLogs, false);
            }
        }
    }

    /**
    * @description Creates Oms log object based on failed upsert result(s)
    * @param results Upsert result list
    */
    private static void insertFailedResults(Database.UpsertResult[] results) {
        if (!results.isEmpty()) {
            List<OmsLog__c> errorLogs = new List<OmsLog__c>();

            for (Database.UpsertResult result : results) {
                if (!result.isSuccess()) {
                    errorLogs.addAll(getResultErrors(result.getErrors()));
                }
            }

            if (!errorLogs.isEmpty()) {
                Database.insert(errorLogs, false);
            }
        }
    }

    /**
    * @description Creates Oms log object based on failed delete result(s)
    * @param results Delete result list
    */
    private static void insertFailedResults(Database.DeleteResult[] results) {
        if (!results.isEmpty()) {
            List<OmsLog__c> errorLogs = new List<OmsLog__c>();

            for (Database.DeleteResult result : results) {
                if (!result.isSuccess()) {
                    errorLogs.addAll(getResultErrors(result.getErrors()));
                }
            }

            if (!errorLogs.isEmpty()) {
                Database.insert(errorLogs, false);
            }
        }
    }

    /**
    * @description Creates Oms log object based on failed undelete result(s)
    * @param results Undelete result list
    */
    private static void insertFailedResults(Database.UndeleteResult[] results) {
        if (!results.isEmpty()) {
            List<OmsLog__c> errorLogs = new List<OmsLog__c>();

            for (Database.UndeleteResult result : results) {
                if (!result.isSuccess()) {
                    errorLogs.addAll(getResultErrors(result.getErrors()));
                }
            }

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
    private static List<OmsLog__c> getResultErrors(Database.Error[] errors) {
        List<OmsLog__c> errorLogs = new List<OmsLog__c>();

        for (Database.Error error : errors) {
            OmsLog__c log = LogUtils.createErrorLog(String.valueOf(error.getStatusCode()), error.getMessage());
            errorLogs.add(log);
        }

        return errorLogs;
    }
}