/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description OrderSummary Api class
*/
public with sharing class OrderSummaryApi extends BaseApi {
    /**
    * @description Create an OrderSummary based on an order
    *   That order is considered the original order for the OrderSummary
    * @param orderId Order id - required
    * @return Order summary output
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
    * @return OrderSummary output
    */
    @SuppressWarnings('PMD.ExcessiveParameterList')
    public ConnectApi.OrderSummaryOutputRepresentation createOrderSummary(String orderId, String name, String orderLifeCycleType, OrderSummaryStatus status) {
        ConnectApi.OrderSummaryInputRepresentation input = new ConnectApi.OrderSummaryInputRepresentation();
        input.orderId = orderId;
        
        if (String.isNotBlank(name)) {
            input.name = name;
        }

        if (String.isNotBlank(orderLifeCycleType)) {
            input.orderLifeCycleType = orderLifeCycleType;
        }

        if (status != null && String.isNotBlank(status.toString())) {
            input.status = status.toString();
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
    * @return Adjust preview output
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
    * @return Adjust submit output
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
    * @return Ensure funds async output
    */
    public ConnectApi.EnsureFundsAsyncOutputRepresentation ensureFundsAsync(String orderSummaryId, String invoiceId) {
        ConnectApi.EnsureFundsAsyncInputRepresentation ensureFundsAsyncInput = new ConnectApi.EnsureFundsAsyncInputRepresentation();
        ensureFundsAsyncInput.invoiceId = invoiceId;

        ConnectApi.EnsureFundsAsyncOutputRepresentation output = ConnectApi.OrderSummary.ensureFundsAsync(orderSummaryId, ensureFundsAsyncInput);
        super.insertFailedResults(output);
        return output;
    }
   

    // public ConnectApi.SubmitCancelOutputRepresentation submitCancel(String orderSummaryId, List<OrderItemSummary> orderItemSummaries) {
    //     ConnectApi.ChangeInputRepresentation changeInput = new ConnectApi.ChangeInputRepresentation();
    //     List<ConnectApi.ChangeItemInputRepresentation> changeItemInputs = new List<ConnectApi.ChangeItemInputRepresentation>();

    //     for (OrderItemSummary orderItemSummary : orderItemSummaries) {
    //         // no cancellation for shipping items
    //         if (orderItemSummary.Type.equalsIgnoreCase(OrderProductType.DELIVERY_CHARGE.toString())) {
    //             continue;
    //         }

    //         ConnectApi.ChangeItemInputRepresentation changeItemInput = new ConnectApi.ChangeItemInputRepresentation();
    //         changeItemInput.orderItemSummaryId = orderItemSummary.Id;
    //         changeItemInput.quantity = orderItemSummary.Quantity;
    //         changeItemInput.reason = 'Unknown';
    //         changeItemInput.shippingReductionFlag = false;
    //         changeItemInputs.add(changeItemInput);
    //     }

    //     changeInput.changeItems = changeItemInputs;

    //     ConnectApi.SubmitCancelOutputRepresentation output = ConnectApi.OrderSummary.submitCancel(orderSummaryId, changeInput);
    //     super.insertFailedResults(output);
    //     return output;
    // }
}