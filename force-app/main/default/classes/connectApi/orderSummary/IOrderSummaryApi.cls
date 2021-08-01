/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 01/08/2021
* @description OrderSummaryApi interface
*   suppress reason: ignore
*/
@suppressWarnings('PMD.ExcessiveParameterList')
public interface IOrderSummaryApi {
    /**
    * @description Create an OrderSummary based on an order
    *   That order is considered the original order for the OrderSummary
    * @param orderId Order id - required
    * @return Id of the created OrderSummary
    */
    ConnectApi.OrderSummaryOutputRepresentation createOrderSummary(String orderId);

    /**
    * @description Create an OrderSummary based on an order
    *   That order is considered the original order for the OrderSummary
    * @param orderId Id of the Order - required
    * @param name OrderNumber of the OrderSummary - optional
    * @param orderLifeCycleType Managed|Unmanaged - optional
    * @param status Status of the OrderSummary - optional
    * @return Id of the created OrderSummary
    */
    ConnectApi.OrderSummaryOutputRepresentation createOrderSummary(String orderId, String name, LifeCycleType orderLifeCycleType, OrderSummaryStatus status);

    /**
    * @description Retrieve the expected results of adjusting
    *   the price of one or more OrderItemSummaries from an OrderSummary,
    *   without actually executing the adjustment. The response data 
    *   contains the financial changes that would result from submitting 
    *   the proposed adjustment
    * @param orderSummaryId Id of OrderSummary - required
    * @param adjustItemInputList List of AdjustItemInputRepresentation object - required
    *   adjustmentType AmountWithTax|AmountWithoutTax|Percentage - required
    *   amount amount of adjustment, must be negative - required
    *   description description of adjustment - optional
    *   orderItem​SummaryId Id of the OrderItemSummary - required
    *   reason reason for the adjustment based on OrderItemSummaryChange - required
    * @return Output representation of the financial changes for an adjust items action.
    *   For a preview action, these values are the expected output. For a submit action, 
    *   these values are the actual output
    */
    ConnectApi.AdjustOrderSummaryOutputRepresentation adjustPreview(String orderSummaryId, List<ConnectApi.AdjustItemInputRepresentation> adjustItemInputList);

    /**
    * @description Adjust the price of one or more OrderItemSummaries from an 
    *   OrderSummary, and create one or two corresponding change orders.
    * @param orderSummaryId Id of the OrderSummary - required
    * @param adjustItemInputList List of AdjustItemInputRepresentation object - required
    *   adjustmentType AmountWithTax|AmountWithoutTax|Percentage - required
    *   amount amount of adjustment, must be negative - required
    *   description description of adjustment - optional
    *   orderItem​SummaryId Id of the OrderItemSummary - required
    *   reason reason for the adjustment based on OrderItemSummaryChange - required
    * @return Output representation of the financial changes for an adjust items action.
    *   For a preview action, these values are the expected output. For a submit action, 
    *   these values are the actual output
    */
    ConnectApi.AdjustOrderSummaryOutputRepresentation adjustSubmit(String orderSummaryId, List<ConnectApi.AdjustItemInputRepresentation> adjustItemInputList);

    /**
    * @description Ensure refunds for a credit memo or excess funds by
    *  sending a request to a payment provider. This method inserts a 
    *  background operation into an asynchronous job queue and returns
    *  the ID of that operation so you can track its status. Payment gateway
    *  responses appear in the payment gateway log and do not affect the
    *  background operation status
    * @param orderSummaryId Id of the OrderSummary - required
    * @param invoiceId - Id of the Invoice - required
    * @return Id of the background operation
    */
    ConnectApi.EnsureFundsAsyncOutputRepresentation ensureFundsAsync(String orderSummaryId, String invoiceId);

    /**
    * @description Retrieve the expected change order values for returning 
    *   one or more OrderItemSummaries from an OrderSummary, without actually
    *   executing the return
    * @param orderSummaryId Id of the OrderSummary - required
    * @param changeInput A list of changes to OrderItemSummaries that make 
    *   up an order change (return) required
    * @return Expected financial values for a proposed return action
    */
    ConnectApi.PreviewReturnOutputRepresentation previewReturn(String orderSummaryId, ConnectApi.ChangeInputRepresentation changeInput);

    /**
    * @description Cancel one or more OrderItemSummaries from an OrderSummary
    *   and create a corresponding change order
    * @param orderSummaryId Id of the OrderSummary - required
    * @param changeInput A list of changes to OrderItemSummaries that make 
    *   up an order change (return) - required
    * @return Id of the change order created for a return action, and a set
    *   of its financial values
    */
    ConnectApi.SubmitReturnOutputRepresentation submitReturn(String orderSummaryId, ConnectApi.ChangeInputRepresentation changeInput);

    /**
    * @description Retrieve the expected change order values for canceling
    *   one or more OrderItemSummaries from an OrderSummary, without actually
    *   executing the cancel
    * @param orderSummaryId Id of the OrderSummary - required
    * @param changeInput A list of changes to OrderItemSummaries that make 
    *   up an order change (cancel) - required
    * @return Expected financial values for a proposed cancel action
    */
    ConnectApi.PreviewCancelOutputRepresentation previewCancel(String orderSummaryId, ConnectApi.ChangeInputRepresentation changeInput);

    /**
    * @description Cancel one or more OrderItemSummaries from an OrderSummary
    *   and create a corresponding change order
    * @param orderSummaryId Id of the OrderSummary - required
    * @param changeInput A list of changes to OrderItemSummaries that make 
    *   up an order change (cancel) - required
    * @return ID of the change order created for a cancel action, and a set of its
    *   financial values
    */
    ConnectApi.SubmitCancelOutputRepresentation submitCancel(String orderSummaryId, ConnectApi.ChangeInputRepresentation changeInput);

    /**
    * @description Create a credit memo to represent the refund for one or 
    *  more change orders associated with an OrderSummary
    * @param orderSummaryId Id of the OrderSummary - required
    * @param changeOrderIds The list of change order Ids - required
    * @return Id of a created Credit Memo
    */
    ConnectApi.CreateCreditMemoOutputRepresentation createCreditMemo(String orderSummaryId, List<String> changeOrderIds);

    /**
    * @description Ensure refunds for a credit memo or excess 
    *   funds by sending a request to a payment provider. This 
    *   method inserts a background operation into an asynchronous
    *   job queue and returns the ID of that operation so you can
    *   track its status. Payment gateway responses appear in the
    *   payment gateway log and do not affect the background operation status
    * @param orderSummaryId Id of the OrderSummary - required
    * @param creditMemoId The Id of the CreditMemo - required
    * @param excessFundsAmount Amount of excess funds to refund - optional
    * @return Id of the background operation
    */
    ConnectApi.EnsureRefundsAsyncOutputRepresentation ensureRefundsAsync(String orderSummaryId, String creditMemoId, Double excessFundsAmount);
}