/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description Fulfillment order type class
*/
public class FulfillmentOrderType extends BaseEnum {
    private static final Map<String, FulfillmentOrderType> TYPES = new Map<String, FulfillmentOrderType>();
    
    public static final FulfillmentOrderType WAREHOUSE = new FulfillmentOrderType(Constants.WAREHOUSE, Constants.WAREHOUSE);
    public static final FulfillmentOrderType RETAIL_STORE = new FulfillmentOrderType(Constants.RETAIL_STORE, Constants.RETAIL_STORE);
    public static final FulfillmentOrderType IN_STORE_PICKUP = new FulfillmentOrderType(Constants.IN_STORE_PICKUP, Constants.IN_STORE_PICKUP);
         
    private FulfillmentOrderType(String typeKey, String typeValue) {
        this.enumKey = typeKey;
        this.enumValue = typeValue;

        TYPES.put(typeKey, this);
    }

    /**
    * @description Returns all types
    * @return Fulfillment order type list
    */
    public static FulfillmentOrderType[] values() {
        return TYPES.values();
    }
}