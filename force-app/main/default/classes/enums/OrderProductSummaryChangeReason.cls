/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 04/07/2021
* @description OrderProductSummaryChangeReason class
*/
public class OrderProductSummaryChangeReason extends BaseEnum {
    private static final Map<String, OrderProductSummaryChangeReason> STATUSES = new Map<String, OrderProductSummaryChangeReason>();
    
    public static final OrderProductSummaryChangeReason UNKNOWN = new OrderProductSummaryChangeReason(Constants.UNKNOWN, Constants.UNKNOWN);
         
    private OrderProductSummaryChangeReason(String statusKey, String statusValue) {
        this.enumKey = statusKey;
        this.enumValue = statusValue;

        STATUSES.put(statusKey, this);
    }

    /**
    * @description Returns all statuses
    * @return OrderProductSummaryChangeReason list
    */
    public static OrderProductSummaryChangeReason[] values() {
        return STATUSES.values();
    }
}