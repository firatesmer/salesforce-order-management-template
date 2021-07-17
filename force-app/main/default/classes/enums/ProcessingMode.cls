/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 14/07/2021
* @description ProcessingMode class
*/
public class ProcessingMode extends BaseEnum {
    private static final Map<String, ProcessingMode> STATUSES = new Map<String, ProcessingMode>();
    
    public static final ProcessingMode EXTERNAL = new ProcessingMode(Constants.EXTERNAL, Constants.EXTERNAL);
    public static final ProcessingMode SALESFORCE = new ProcessingMode(Constants.SALESFORCE, Constants.SALESFORCE);
         
    private ProcessingMode(String statusKey, String statusValue) {
        this.enumKey = statusKey;
        this.enumValue = statusValue;

        STATUSES.put(statusKey, this);
    }

    /**
    * @description Returns all statuses
    * @return ProcessingMode list
    */
    public static ProcessingMode[] values() {
        return STATUSES.values();
    }
}