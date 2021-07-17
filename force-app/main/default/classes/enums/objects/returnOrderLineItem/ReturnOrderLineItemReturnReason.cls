/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 15/07/2021
* @description ReturnOrderLineItemReturnReason class
*/
public class ReturnOrderLineItemReturnReason extends BaseEnum {
    private static final Map<String, ReturnOrderLineItemReturnReason> STATUSES = new Map<String, ReturnOrderLineItemReturnReason>();
    
    public static final ReturnOrderLineItemReturnReason DAMAGED = new ReturnOrderLineItemReturnReason(Constants.DAMAGED, Constants.DAMAGED);
    public static final ReturnOrderLineItemReturnReason DEFECTIVE = new ReturnOrderLineItemReturnReason(Constants.DEFECTIVE, Constants.DEFECTIVE);
    public static final ReturnOrderLineItemReturnReason DUPLICATE_ORDER = new ReturnOrderLineItemReturnReason(Constants.DUPLICATE_ORDER, Constants.DUPLICATE_ORDER);
    public static final ReturnOrderLineItemReturnReason WRONG_ITEM = new ReturnOrderLineItemReturnReason(Constants.WRONG_ITEM, Constants.WRONG_ITEM);
    public static final ReturnOrderLineItemReturnReason WRONG_QUANTITY = new ReturnOrderLineItemReturnReason(Constants.WRONG_QUANTITY, Constants.WRONG_QUANTITY);
    public static final ReturnOrderLineItemReturnReason NOT_SATISFIED = new ReturnOrderLineItemReturnReason(Constants.NOT_SATISFIED, Constants.NOT_SATISFIED);
    public static final ReturnOrderLineItemReturnReason OUTDATED = new ReturnOrderLineItemReturnReason(Constants.OUTDATED, Constants.OUTDATED);
    public static final ReturnOrderLineItemReturnReason OTHER = new ReturnOrderLineItemReturnReason(Constants.OTHER, Constants.OTHER);
         
    private ReturnOrderLineItemReturnReason(String statusKey, String statusValue) {
        this.enumKey = statusKey;
        this.enumValue = statusValue;

        STATUSES.put(statusKey, this);
    }

    /**
    * @description Returns all statuses
    * @return ReturnOrderLineItemReturnReason list
    */
    public static ReturnOrderLineItemReturnReason[] values() {
        return STATUSES.values();
    }
}