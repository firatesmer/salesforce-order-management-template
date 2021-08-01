/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 01/08/2021
* @description OrderPaymentSummaryApi interface
*/
public interface IOrderPaymentSummaryApi {
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
    ConnectApi.CreateOrderPaymentSummaryOutputRepresentation createOrderPaymentSummary(String orderSummaryId, String paymentAuthorizationId, List<String> paymentIds);
}