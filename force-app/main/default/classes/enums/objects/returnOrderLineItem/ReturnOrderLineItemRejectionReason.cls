/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 19/07/2021
* @description ReturnOrderLineItemRejectionReason class
*/
public class ReturnOrderLineItemRejectionReason extends BaseEnum {
    private static final Map<String, ReturnOrderLineItemRejectionReason> STATUSES = new Map<String, ReturnOrderLineItemRejectionReason>();
    
    public static final ReturnOrderLineItemRejectionReason DAMAGED_ITEM = new ReturnOrderLineItemRejectionReason(Constants.DAMAGED_ITEM, Constants.DAMAGED_ITEM);
    public static final ReturnOrderLineItemRejectionReason MISSING_ITEM_OR_PART = new ReturnOrderLineItemRejectionReason(Constants.MISSING_ITEM_OR_PART, Constants.MISSING_ITEM_OR_PART);
    public static final ReturnOrderLineItemRejectionReason WRONG_ITEM = new ReturnOrderLineItemRejectionReason(Constants.WRONG_ITEM, Constants.WRONG_ITEM);
    public static final ReturnOrderLineItemRejectionReason EXPIRED_WARRANTY = new ReturnOrderLineItemRejectionReason(Constants.WRONG_QUANTITY, Constants.WRONG_QUANTITY);
         
    private ReturnOrderLineItemRejectionReason(String statusKey, String statusValue) {
        this.enumKey = statusKey;
        this.enumValue = statusValue;

        STATUSES.put(statusKey, this);
    }

    /**
    * @description Returns all statuses
    * @return ReturnOrderLineItemRejectionReason list
    */
    public static ReturnOrderLineItemRejectionReason[] values() {
        return STATUSES.values();
    }
}