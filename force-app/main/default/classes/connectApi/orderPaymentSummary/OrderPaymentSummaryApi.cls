/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 11/07/2021
* @description Work with payments in Order Management
*/
public virtual without sharing class OrderPaymentSummaryApi extends ConnectApiBase implements IOrderPaymentSummaryApi {
    /**
    * @description Create an OrderPaymentSummary
    *   for an OrderSummary. Specify a payment
    *   authorization or payments that share the
    *   same payment method. In an org with the
    *   multicurrency feature enabled, the
    *   OrderPaymentSummary inherits the
    *   CurrencyIsoCode value from the OrderSummary
    * @param orderSummaryId Id of the OrderSummary - required
    * @param paymentAuthorizationId Id of the PaymentAuthorization
    *   - either this or paymentIds should be set
    * @param paymentIds List of Ids of the payments
    *   - either this or paymentAuthorizationId should be set
    * @return Id of the created OrderPaymentSummary
    */
    public virtual ConnectApi.CreateOrderPaymentSummaryOutputRepresentation createOrderPaymentSummary(String orderSummaryId, String paymentAuthorizationId, List<String> paymentIds) {
        ConnectApi.CreateOrderPaymentSummaryInputRepresentation input = new ConnectApi.CreateOrderPaymentSummaryInputRepresentation();
        input.orderSummaryId  = orderSummaryId;

        if (String.isNotEmpty(paymentAuthorizationId)) {
            input.paymentAuthorizationId = paymentAuthorizationId;
        }

        if (paymentIds != null && !paymentIds.isEmpty()) {
            input.paymentIds = paymentIds;
        }

        ConnectApi.CreateOrderPaymentSummaryOutputRepresentation output = ConnectApi.OrderPaymentSummary.createOrderPaymentSummary(input);
        super.insertFailedResults(output);
        return output;
    }
}