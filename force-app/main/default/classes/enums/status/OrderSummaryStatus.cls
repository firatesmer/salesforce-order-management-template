/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description OrderSummaryStatus class
*/
public class OrderSummaryStatus extends BaseEnum {
    private static final Map<String, OrderSummaryStatus> STATUSES = new Map<String, OrderSummaryStatus>();
    
    public static final OrderSummaryStatus CREATED = new OrderSummaryStatus(Constants.CREATED, Constants.CREATED);
    public static final OrderSummaryStatus APPROVED = new OrderSummaryStatus(Constants.APPROVED, Constants.APPROVED);
    public static final OrderSummaryStatus WAITING_TO_FULFILL = new OrderSummaryStatus(Constants.WAITING_TO_FULFILL, Constants.WAITING_TO_FULFILL);
    public static final OrderSummaryStatus FULFILLED = new OrderSummaryStatus(Constants.FULFILLED, Constants.FULFILLED);
         
    private OrderSummaryStatus(String statusKey, String statusValue) {
        this.enumKey = statusKey;
        this.enumValue = statusValue;

        STATUSES.put(statusKey, this);
    }

    /**
    * @description Returns all statuses
    * @return OrderSummaryStatus list
    */
    public static OrderSummaryStatus[] values() {
        return STATUSES.values();
    }
}