/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description Invoice status class
*/
public class InvoiceStatus extends BaseEnum {
    private static final Map<String, InvoiceStatus> STATUSES = new Map<String, InvoiceStatus>();
    
    public static final InvoiceStatus DRAFT = new InvoiceStatus(Constants.DRAFT, Constants.DRAFT);
    public static final InvoiceStatus PENDING = new InvoiceStatus(Constants.PENDING, Constants.PENDING);
    public static final InvoiceStatus POSTED = new InvoiceStatus(Constants.POSTED, Constants.POSTED);
    public static final InvoiceStatus CANCELED = new InvoiceStatus(Constants.CANCELED, Constants.CANCELED);
    public static final InvoiceStatus ERROR_POSTING = new InvoiceStatus(Constants.ERROR_POSTING, Constants.ERROR_POSTING);
         
    private InvoiceStatus(String statusKey, String statusValue) {
        this.enumKey = statusKey;
        this.enumValue = statusValue;

        STATUSES.put(statusKey, this);
    }

    /**
    * @description Returns all statuses
    * @return Invoice status list
    */
    public static InvoiceStatus[] values() {
        return STATUSES.values();
    }
}
