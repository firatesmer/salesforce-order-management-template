/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description Work with orders in Order Management
*/
public with sharing class OrderSummaryApi extends BaseApi {
    /**
    * @description Create an OrderSummary based on an order
    *   That order is considered the original order for the OrderSummary
    * @param orderId Order id - required
    * @return Id of the created OrderSummary
    */
    public ConnectApi.OrderSummaryOutputRepresentation createOrderSummary(String orderId) {
        ConnectApi.OrderSummaryInputRepresentation input = new ConnectApi.OrderSummaryInputRepresentation();
        input.orderId = orderId;

        ConnectApi.OrderSummaryOutputRepresentation output = ConnectApi.OrderSummaryCreation.createOrderSummary(input);
        super.insertFailedResults(output);
        return output;
    }

    /**
    * @description Create an OrderSummary based on an order
    *   That order is considered the original order for the OrderSummary
    *   suppress reason: ignore
    * @param orderId Id of the Order - required
    * @param name OrderNumber of the OrderSummary - optional
    * @param orderLifeCycleType Managed|Unmanaged - optional
    * @param status Status of the OrderSummary - optional
    * @return Id of the created OrderSummary
    */
    @suppressWarnings('PMD.ExcessiveParameterList')
    public ConnectApi.OrderSummaryOutputRepresentation createOrderSummary(String orderId, String name, LifeCycleType orderLifeCycleType, OrderSummaryStatus status) {
        ConnectApi.OrderSummaryInputRepresentation input = new ConnectApi.OrderSummaryInputRepresentation();
        input.orderId = orderId;
        
        if (String.isNotBlank(name)) {
            input.name = name;
        }

        if (orderLifeCycleType != null) {
            input.orderLifeCycleType = orderLifeCycleType.enumValue;
        }

        if (status != null) {
            input.status = status.enumValue;
        }

        ConnectApi.OrderSummaryOutputRepresentation output = ConnectApi.OrderSummaryCreation.createOrderSummary(input);
        super.insertFailedResults(output);
        return output;
    }

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
    public ConnectApi.AdjustOrderSummaryOutputRepresentation adjustPreview(String orderSummaryId, List<ConnectApi.AdjustItemInputRepresentation> adjustItemInputList) {
        ConnectApi.AdjustOrderItemSummaryInputRepresentation adjustInput = new ConnectApi.AdjustOrderItemSummaryInputRepresentation();
        adjustInput.adjustItems = adjustItemInputList;

        ConnectApi.AdjustOrderSummaryOutputRepresentation output = ConnectApi.OrderSummary.adjustPreview(orderSummaryId, adjustInput);
        super.insertFailedResults(output);
        return output;
    }

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
    public ConnectApi.AdjustOrderSummaryOutputRepresentation adjustSubmit(String orderSummaryId, List<ConnectApi.AdjustItemInputRepresentation> adjustItemInputList) {
        ConnectApi.AdjustOrderItemSummaryInputRepresentation adjustInput = new ConnectApi.AdjustOrderItemSummaryInputRepresentation();
        adjustInput.adjustItems = adjustItemInputList;

        ConnectApi.AdjustOrderSummaryOutputRepresentation output = ConnectApi.OrderSummary.adjustSubmit(orderSummaryId, adjustInput);
        super.insertFailedResults(output);
        return output;
    }

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
    public ConnectApi.EnsureFundsAsyncOutputRepresentation ensureFundsAsync(String orderSummaryId, String invoiceId) {
        ConnectApi.EnsureFundsAsyncInputRepresentation ensureFundsAsyncInput = new ConnectApi.EnsureFundsAsyncInputRepresentation();
        ensureFundsAsyncInput.invoiceId = invoiceId;

        ConnectApi.EnsureFundsAsyncOutputRepresentation output = ConnectApi.OrderSummary.ensureFundsAsync(orderSummaryId, ensureFundsAsyncInput);
        super.insertFailedResults(output);
        return output;
    }

    /**
    * @description Retrieve the expected change order values for returning 
    *   one or more OrderItemSummaries from an OrderSummary, without actually
    *   executing the return
    * @param orderSummaryId Id of the OrderSummary - required
    * @param changeInput A list of changes to OrderItemSummaries that make 
    *   up an order change (return) required
    * @return Expected financial values for a proposed return action
    */
    public ConnectApi.PreviewReturnOutputRepresentation previewReturn(String orderSummaryId, ConnectApi.ChangeInputRepresentation changeInput) {
        ConnectApi.PreviewReturnOutputRepresentation output = ConnectApi.OrderSummary.previewReturn(orderSummaryId, changeInput);
        super.insertFailedResults(output);
        return output;
    }

    /**
    * @description Cancel one or more OrderItemSummaries from an OrderSummary
    *   and create a corresponding change order
    * @param orderSummaryId Id of the OrderSummary - required
    * @param changeInput A list of changes to OrderItemSummaries that make 
    *   up an order change (return) - required
    * @return Id of the change order created for a return action, and a set
    *   of its financial values
    */
    public ConnectApi.SubmitReturnOutputRepresentation submitReturn(String orderSummaryId, ConnectApi.ChangeInputRepresentation changeInput) {
        ConnectApi.SubmitReturnOutputRepresentation output = ConnectApi.OrderSummary.submitReturn(orderSummaryId, changeInput);
        super.insertFailedResults(output);
        return output;
    }

    /**
    * @description Retrieve the expected change order values for canceling
    *   one or more OrderItemSummaries from an OrderSummary, without actually
    *   executing the cancel
    * @param orderSummaryId Id of the OrderSummary - required
    * @param changeInput A list of changes to OrderItemSummaries that make 
    *   up an order change (cancel) - required
    * @return Expected financial values for a proposed cancel action
    */
    public ConnectApi.PreviewCancelOutputRepresentation previewCancel(String orderSummaryId, ConnectApi.ChangeInputRepresentation changeInput) {
        ConnectApi.PreviewCancelOutputRepresentation output = ConnectApi.OrderSummary.previewCancel(orderSummaryId, changeInput);
        super.insertFailedResults(output);
        return output;
    }

    /**
    * @description Cancel one or more OrderItemSummaries from an OrderSummary
    *   and create a corresponding change order
    * @param orderSummaryId Id of the OrderSummary - required
    * @param changeInput A list of changes to OrderItemSummaries that make 
    *   up an order change (cancel) - required
    * @return ID of the change order created for a cancel action, and a set of its
    *   financial values
    */
    public ConnectApi.SubmitCancelOutputRepresentation submitCancel(String orderSummaryId, ConnectApi.ChangeInputRepresentation changeInput) {
        ConnectApi.SubmitCancelOutputRepresentation output = ConnectApi.OrderSummary.submitCancel(orderSummaryId, changeInput);
        super.insertFailedResults(output);
        return output;
    }

    /**
    * @description Create a credit memo to represent the refund for one or 
    *  more change orders associated with an OrderSummary
    * @param orderSummaryId Id of the OrderSummary - required
    * @param changeOrderIds The list of change order Ids - required
    * @return Id of a created Credit Memo
    */
    public ConnectApi.CreateCreditMemoOutputRepresentation createCreditMemo(String orderSummaryId, List<String> changeOrderIds) {
        ConnectApi.CreateCreditMemoInputRepresentation input = new ConnectApi.CreateCreditMemoInputRepresentation();
        input.changeOrderIds = changeOrderIds;

        ConnectApi.CreateCreditMemoOutputRepresentation output = ConnectApi.OrderSummary.createCreditMemo(orderSummaryId, input);
        super.insertFailedResults(output);
        return output;
    }

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
    public ConnectApi.EnsureRefundsAsyncOutputRepresentation ensureRefundsAsync(String orderSummaryId, String creditMemoId, Double excessFundsAmount) {
        ConnectApi.EnsureRefundsAsyncInputRepresentation ensureRefundAsyncInput = new ConnectApi.EnsureRefundsAsyncInputRepresentation();
        ensureRefundAsyncInput.creditMemoId = creditMemoId;

        if (excessFundsAmount != null && excessFundsAmount > 0) {
            ensureRefundAsyncInput.excessFundsAmount = excessFundsAmount;
        }

        ConnectApi.EnsureRefundsAsyncOutputRepresentation output = ConnectApi.OrderSummary.ensureRefundsAsync(orderSummaryId, ensureRefundAsyncInput);
        super.insertFailedResults(output);
        return output;
    }
}