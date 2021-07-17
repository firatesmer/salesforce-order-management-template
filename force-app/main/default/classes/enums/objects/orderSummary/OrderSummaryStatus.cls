/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description OrderSummaryStatus class
*/
public class OrderSummaryStatus extends BaseEnum {
    private static final Map<String, OrderSummaryStatus> STATUSES = new Map<String, OrderSummaryStatus>();
    
    public static final OrderSummaryStatus CREATED = new OrderSummaryStatus(Constants.CREATED, Constants.CREATED);
         
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