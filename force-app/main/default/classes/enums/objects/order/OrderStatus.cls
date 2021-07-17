/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 15/07/2021
* @description OrderStatus class
*/
public class OrderStatus extends BaseEnum {
    private static final Map<String, OrderStatus> TYPES = new Map<String, OrderStatus>();
    
    public static final OrderStatus DRAFT = new OrderStatus(Constants.DRAFT, Constants.DRAFT);
    public static final OrderStatus ACTIVATED = new OrderStatus(Constants.ACTIVATED, Constants.ACTIVATED);
         
    private OrderStatus(String typeKey, String typeValue) {
        this.enumKey = typeKey;
        this.enumValue = typeValue;

        TYPES.put(typeKey, this);
    }

    /**
    * @description Returns all types
    * @return OrderStatus list
    */
    public static OrderStatus[] values() {
        return TYPES.values();
    }
}