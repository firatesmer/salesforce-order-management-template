/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 15/07/2021
* @description PaymentAuthorizationStatus class
*/
public class PaymentAuthorizationStatus extends BaseEnum {
    private static final Map<String, PaymentAuthorizationStatus> STATUSES = new Map<String, PaymentAuthorizationStatus>();
    
    public static final PaymentAuthorizationStatus DRAFT = new PaymentAuthorizationStatus(Constants.DRAFT, Constants.DRAFT);
    public static final PaymentAuthorizationStatus PROCESSED = new PaymentAuthorizationStatus(Constants.PROCESSED, Constants.PROCESSED);
    public static final PaymentAuthorizationStatus CANCELED = new PaymentAuthorizationStatus(Constants.CANCELED, Constants.CANCELED);
    public static final PaymentAuthorizationStatus PENDING = new PaymentAuthorizationStatus(Constants.PENDING, Constants.PENDING);
    public static final PaymentAuthorizationStatus FAILED = new PaymentAuthorizationStatus(Constants.FAILED, Constants.FAILED);
         
    private PaymentAuthorizationStatus(String statusKey, String statusValue) {
        this.enumKey = statusKey;
        this.enumValue = statusValue;

        STATUSES.put(statusKey, this);
    }

    /**
    * @description Returns all statuses
    * @return PaymentAuthorizationStatus list
    */
    public static PaymentAuthorizationStatus[] values() {
        return STATUSES.values();
    }
}