/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description Fulfillment order status class
*/
public class FulfillmentOrderStatus extends BaseEnum {
    private static final Map<String, FulfillmentOrderStatus> STATUSES = new Map<String, FulfillmentOrderStatus>();
    
    public static final FulfillmentOrderStatus DRAFT = new FulfillmentOrderStatus(Constants.DRAFT, Constants.DRAFT);
    public static final FulfillmentOrderStatus ALLOCATED = new FulfillmentOrderStatus(Constants.ALLOCATED, Constants.ALLOCATED);
    public static final FulfillmentOrderStatus ASSIGNED = new FulfillmentOrderStatus(Constants.ASSIGNED, Constants.ASSIGNED);
    public static final FulfillmentOrderStatus PICKPACK = new FulfillmentOrderStatus(Constants.PICKPACK, Constants.PICKPACK);
    public static final FulfillmentOrderStatus FULFILLED = new FulfillmentOrderStatus(Constants.FULFILLED, Constants.FULFILLED);
    public static final FulfillmentOrderStatus CANCELLED = new FulfillmentOrderStatus(Constants.CANCELLED, Constants.CANCELLED);
         
    private FulfillmentOrderStatus(String statusKey, String statusValue) {
        this.enumKey = statusKey;
        this.enumValue = statusValue;

        STATUSES.put(statusKey, this);
    }

    /**
    * @description Returns all statuses
    * @return Fulfillment order status list
    */
    public static FulfillmentOrderStatus[] values() {
        return STATUSES.values();
    }
}