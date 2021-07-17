/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description CardPaymentMethodType class
*/
public class CardPaymentMethodType extends BaseEnum {
    private static final Map<String, CardPaymentMethodType> TYPES = new Map<String, CardPaymentMethodType>();
    
    public static final CardPaymentMethodType VISA = new CardPaymentMethodType(Constants.VISA, Constants.VISA);
    public static final CardPaymentMethodType MASTER_CARD = new CardPaymentMethodType(Constants.MASTER_CARD, Constants.MASTER_CARD);
    public static final CardPaymentMethodType AMERICAN_EXPRESS = new CardPaymentMethodType(Constants.AMERICAN_EXPRESS, Constants.AMERICAN_EXPRESS);
    public static final CardPaymentMethodType DINERS_CLUB = new CardPaymentMethodType(Constants.DINERS_CLUB, Constants.DINERS_CLUB);
    public static final CardPaymentMethodType JCB = new CardPaymentMethodType(Constants.JCB, Constants.JCB);
    public static final CardPaymentMethodType MAESTRO = new CardPaymentMethodType(Constants.MAESTRO, Constants.MAESTRO);
         
    private CardPaymentMethodType(String typeKey, String typeValue) {
        this.enumKey = typeKey;
        this.enumValue = typeValue;

        TYPES.put(typeKey, this);
    }

    /**
    * @description Returns all types
    * @return CardPaymentMethodType list
    */
    public static CardPaymentMethodType[] values() {
        return TYPES.values();
    }
}