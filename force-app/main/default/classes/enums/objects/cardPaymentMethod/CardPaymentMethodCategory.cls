/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description CardPaymentMethodCategory class
*/
public class CardPaymentMethodCategory extends BaseEnum {
    private static final Map<String, CardPaymentMethodCategory> STATUSES = new Map<String, CardPaymentMethodCategory>();
    
    public static final CardPaymentMethodCategory CREDIT_CARD = new CardPaymentMethodCategory(Constants.CREDIT_CARD, Constants.CREDIT_CARD);
    public static final CardPaymentMethodCategory DEBIT_CARD = new CardPaymentMethodCategory(Constants.DEBIT_CARD, Constants.DEBIT_CARD);
         
    private CardPaymentMethodCategory(String statusKey, String statusValue) {
        this.enumKey = statusKey;
        this.enumValue = statusValue;

        STATUSES.put(statusKey, this);
    }

    /**
    * @description Returns all statuses
    * @return CardPaymentMethodCategory list
    */
    public static CardPaymentMethodCategory[] values() {
        return STATUSES.values();
    }
}