/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description CardPaymentMethodStatus class
*/
public class CardPaymentMethodStatus extends BaseEnum {
    private static final Map<String, CardPaymentMethodStatus> STATUSES = new Map<String, CardPaymentMethodStatus>();
    
    public static final CardPaymentMethodStatus ACTIVE = new CardPaymentMethodStatus(Constants.ACTIVE, Constants.ACTIVE);
    public static final CardPaymentMethodStatus INACTIVE = new CardPaymentMethodStatus(Constants.INACTIVE, Constants.INACTIVE);
    public static final CardPaymentMethodStatus CANCELED = new CardPaymentMethodStatus(Constants.CANCELED, Constants.CANCELED);
         
    private CardPaymentMethodStatus(String statusKey, String statusValue) {
        this.enumKey = statusKey;
        this.enumValue = statusValue;

        STATUSES.put(statusKey, this);
    }

    /**
    * @description Returns all statuses
    * @return CardPaymentMethodStatus list
    */
    public static CardPaymentMethodStatus[] values() {
        return STATUSES.values();
    }
}