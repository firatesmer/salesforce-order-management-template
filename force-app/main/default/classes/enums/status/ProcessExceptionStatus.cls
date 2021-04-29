/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description Process exception status class
*/
public class ProcessExceptionStatus extends BaseEnum {
    private static final Map<String, ProcessExceptionStatus> STATUSES = new Map<String, ProcessExceptionStatus>();
    
    public static final ProcessExceptionStatus NEW_C = new ProcessExceptionStatus(Constants.NEW_C, Constants.NEW_C);
    public static final ProcessExceptionStatus IGNORED = new ProcessExceptionStatus(Constants.IGNORED, Constants.IGNORED);
    public static final ProcessExceptionStatus RESOLVED = new ProcessExceptionStatus(Constants.RESOLVED, Constants.RESOLVED);
         
    private ProcessExceptionStatus(String statusKey, String statusValue) {
        this.enumKey = statusKey;
        this.enumValue = statusValue;

        STATUSES.put(statusKey, this);
    }

    /**
    * @description Returns all statuses
    * @return Process exception status list
    */
    public static ProcessExceptionStatus[] values() {
        return STATUSES.values();
    }
}