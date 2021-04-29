/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description Return order status class
*/
public class ReturnOrderStatus extends BaseEnum {
    private static final Map<String, ReturnOrderStatus> STATUSES = new Map<String, ReturnOrderStatus>();
    
    public static final ReturnOrderStatus DRAFT = new ReturnOrderStatus(Constants.DRAFT, Constants.DRAFT);
    public static final ReturnOrderStatus SUBMITTED = new ReturnOrderStatus(Constants.SUBMITTED, Constants.SUBMITTED);
    public static final ReturnOrderStatus APPROVED = new ReturnOrderStatus(Constants.APPROVED, Constants.APPROVED);
    public static final ReturnOrderStatus CANCELLED = new ReturnOrderStatus(Constants.CANCELLED, Constants.CANCELLED);
    public static final ReturnOrderStatus CLOSED = new ReturnOrderStatus(Constants.CLOSED, Constants.CLOSED);
         
    private ReturnOrderStatus(String statusKey, String statusValue) {
        this.enumKey = statusKey;
        this.enumValue = statusValue;

        STATUSES.put(statusKey, this);
    }

    /**
    * @description Returns all statuses
    * @return Return order status list
    */
    public static ReturnOrderStatus[] values() {
        return STATUSES.values();
    }
}