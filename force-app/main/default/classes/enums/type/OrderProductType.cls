/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description OrderProductType class
*/
public class OrderProductType extends BaseEnum {
    private static final Map<String, OrderProductType> TYPES = new Map<String, OrderProductType>();
    
    public static final OrderProductType ORDER_PRODUCT = new OrderProductType(Constants.ORDER_PRODUCT, Constants.ORDER_PRODUCT);
    public static final OrderProductType DELIVERY_CHARGE = new OrderProductType(Constants.DELIVERY_CHARGE, Constants.DELIVERY_CHARGE);
         
    private OrderProductType(String typeKey, String typeValue) {
        this.enumKey = typeKey;
        this.enumValue = typeValue;

        TYPES.put(typeKey, this);
    }

    /**
    * @description Returns all types
    * @return OrderProductType list
    */
    public static OrderProductType[] values() {
        return TYPES.values();
    }
}