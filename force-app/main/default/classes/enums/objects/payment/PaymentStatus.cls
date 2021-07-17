/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 11/07/2021
* @description PaymentStatus class
*/
public class PaymentStatus extends BaseEnum {
    private static final Map<String, PaymentStatus> STATUSES = new Map<String, PaymentStatus>();
    
    public static final PaymentStatus DRAFT = new PaymentStatus(Constants.DRAFT, Constants.DRAFT);
    public static final PaymentStatus PROCESSED = new PaymentStatus(Constants.PROCESSED, Constants.PROCESSED);
    public static final PaymentStatus CANCELED = new PaymentStatus(Constants.CANCELED, Constants.CANCELED);
    public static final PaymentStatus PENDING = new PaymentStatus(Constants.PENDING, Constants.PENDING);
    public static final PaymentStatus FAILED = new PaymentStatus(Constants.FAILED, Constants.FAILED);
         
    private PaymentStatus(String statusKey, String statusValue) {
        this.enumKey = statusKey;
        this.enumValue = statusValue;

        STATUSES.put(statusKey, this);
    }

    /**
    * @description Returns all statuses
    * @return PaymentStatus list
    */
    public static PaymentStatus[] values() {
        return STATUSES.values();
    }
}