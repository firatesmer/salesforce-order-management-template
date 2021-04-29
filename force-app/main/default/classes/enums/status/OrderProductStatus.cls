/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description OrderProduct (item) status class
*/
public class OrderProductStatus extends BaseEnum {
    private static final Map<String, OrderProductStatus> STATUSES = new Map<String, OrderProductStatus>();
    
    public static final OrderProductStatus ORDERED = new OrderProductStatus(Constants.ORDERED, Constants.ORDERED);
    public static final OrderProductStatus CANCELED = new OrderProductStatus(Constants.CANCELED, Constants.CANCELED);
    public static final OrderProductStatus ALLOCATED = new OrderProductStatus(Constants.ALLOCATED, Constants.ALLOCATED);
    public static final OrderProductStatus PARTIALLY_ALLOCATED = new OrderProductStatus(Constants.PARTIALLY_ALLOCATED, Constants.PARTIALLY_ALLOCATED);
    public static final OrderProductStatus PAID = new OrderProductStatus(Constants.PAID, Constants.PAID);
    public static final OrderProductStatus RESHIPPED = new OrderProductStatus(Constants.RESHIPPED, Constants.RESHIPPED);
    public static final OrderProductStatus FULFILLED = new OrderProductStatus(Constants.FULFILLED, Constants.FULFILLED);
    public static final OrderProductStatus PARTIALLY_FULFILLED = new OrderProductStatus(Constants.PARTIALLY_FULFILLED, Constants.PARTIALLY_FULFILLED);
    public static final OrderProductStatus RETURNED = new OrderProductStatus(Constants.RETURNED, Constants.RETURNED);
         
    private OrderProductStatus(String statusKey, String statusValue) {
        this.enumKey = statusKey;
        this.enumValue = statusValue;

        STATUSES.put(statusKey, this);
    }

    /**
    * @description Returns all statuses
    * @return Order product status list
    */
    public static OrderProductStatus[] values() {
        return STATUSES.values();
    }
}