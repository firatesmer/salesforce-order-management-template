/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 04/07/2021
* @description OrderItemSummaryChangeReason class
*/
public class OrderItemSummaryChangeReason extends BaseEnum {
    private static final Map<String, OrderItemSummaryChangeReason> STATUSES = new Map<String, OrderItemSummaryChangeReason>();
    
    public static final OrderItemSummaryChangeReason UNKNOWN = new OrderItemSummaryChangeReason(Constants.UNKNOWN, Constants.UNKNOWN);
         
    private OrderItemSummaryChangeReason(String statusKey, String statusValue) {
        this.enumKey = statusKey;
        this.enumValue = statusValue;

        STATUSES.put(statusKey, this);
    }

    /**
    * @description Returns all statuses
    * @return OrderItemSummaryChangeReason list
    */
    public static OrderItemSummaryChangeReason[] values() {
        return STATUSES.values();
    }
}