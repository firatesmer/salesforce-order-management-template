/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 11/07/2021
* @description PaymentType class
*/
public class PaymentType extends BaseEnum {
    private static final Map<String, PaymentType> STATUSES = new Map<String, PaymentType>();
    
    public static final PaymentType CAPTURE = new PaymentType(Constants.CAPTURE, Constants.CAPTURE);
    public static final PaymentType SALE = new PaymentType(Constants.SALE, Constants.SALE);
         
    private PaymentType(String statusKey, String statusValue) {
        this.enumKey = statusKey;
        this.enumValue = statusValue;

        STATUSES.put(statusKey, this);
    }

    /**
    * @description Returns all statuses
    * @return PaymentType list
    */
    public static PaymentType[] values() {
        return STATUSES.values();
    }
}