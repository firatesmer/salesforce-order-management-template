/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description OrderItemType class
*/
public class OrderItemType extends BaseEnum {
    private static final Map<String, OrderItemType> TYPES = new Map<String, OrderItemType>();
    
    public static final OrderItemType ORDER_PRODUCT = new OrderItemType(Constants.ORDER_PRODUCT, Constants.ORDER_PRODUCT);
    public static final OrderItemType DELIVERY_CHARGE = new OrderItemType(Constants.DELIVERY_CHARGE, Constants.DELIVERY_CHARGE);
         
    private OrderItemType(String typeKey, String typeValue) {
        this.enumKey = typeKey;
        this.enumValue = typeValue;

        TYPES.put(typeKey, this);
    }

    /**
    * @description Returns all types
    * @return OrderItemType list
    */
    public static OrderItemType[] values() {
        return TYPES.values();
    }
}