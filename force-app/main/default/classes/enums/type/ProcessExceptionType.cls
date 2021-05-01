/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description ProcessExceptionType class
*/
public class ProcessExceptionType extends BaseEnum {
    private static final Map<String, ProcessExceptionType> TYPES = new Map<String, ProcessExceptionType>();
    
    public static final ProcessExceptionType ORDER_ACTIVATION = new ProcessExceptionType(Constants.ORDER_ACTIVATION, Constants.ORDER_ACTIVATION);
    public static final ProcessExceptionType ORDER_APPROVAL = new ProcessExceptionType(Constants.ORDER_APPROVAL, Constants.ORDER_APPROVAL);
    public static final ProcessExceptionType FULFILLMENT = new ProcessExceptionType(Constants.FULFILLMENT, Constants.FULFILLMENT);
    public static final ProcessExceptionType PAYMENT = new ProcessExceptionType(Constants.PAYMENT, Constants.PAYMENT);
    public static final ProcessExceptionType INVOICING = new ProcessExceptionType(Constants.INVOICING, Constants.INVOICING);
         
    private ProcessExceptionType(String typeKey, String typeValue) {
        this.enumKey = typeKey;
        this.enumValue = typeValue;

        TYPES.put(typeKey, this);
    }

    /**
    * @description Returns all types
    * @return ProcessExceptionType list
    */
    public static ProcessExceptionType[] values() {
        return TYPES.values();
    }
}