/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description OrderItemStatus (OrderItem) class
*/
public class OrderItemStatus extends BaseEnum {
    private static final Map<String, OrderItemStatus> STATUSES = new Map<String, OrderItemStatus>();
    
    public static final OrderItemStatus ORDERED = new OrderItemStatus(Constants.ORDERED, Constants.ORDERED);
    public static final OrderItemStatus CANCELED = new OrderItemStatus(Constants.CANCELED, Constants.CANCELED);
    public static final OrderItemStatus ALLOCATED = new OrderItemStatus(Constants.ALLOCATED, Constants.ALLOCATED);
    public static final OrderItemStatus PARTIALLY_ALLOCATED = new OrderItemStatus(Constants.PARTIALLY_ALLOCATED, Constants.PARTIALLY_ALLOCATED);
    public static final OrderItemStatus PAID = new OrderItemStatus(Constants.PAID, Constants.PAID);
    public static final OrderItemStatus RESHIPPED = new OrderItemStatus(Constants.RESHIPPED, Constants.RESHIPPED);
    public static final OrderItemStatus FULFILLED = new OrderItemStatus(Constants.FULFILLED, Constants.FULFILLED);
    public static final OrderItemStatus PARTIALLY_FULFILLED = new OrderItemStatus(Constants.PARTIALLY_FULFILLED, Constants.PARTIALLY_FULFILLED);
    public static final OrderItemStatus RETURNED = new OrderItemStatus(Constants.RETURNED, Constants.RETURNED);
         
    private OrderItemStatus(String statusKey, String statusValue) {
        this.enumKey = statusKey;
        this.enumValue = statusValue;

        STATUSES.put(statusKey, this);
    }

    /**
    * @description Returns all statuses
    * @return OrderItemStatus list
    */
    public static OrderItemStatus[] values() {
        return STATUSES.values();
    }
}