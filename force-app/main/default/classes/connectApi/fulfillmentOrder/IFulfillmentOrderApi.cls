/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 01/08/2021
* @description FulfillmentOrderApi interface
*/
public interface IFulfillmentOrderApi {
    /**
    * @description Create one or more FulfillmentOrders 
    *   and FulfillmentOrderLineItems for an OrderDeliveryGroupSummary,
    *   which defines a delivery method and recipient for an OrderSummary.
    *   You specify the OrderItemSummaries to allocate, which can be 
    *   fulfilled from different locations. Specifying multiple fulfillment
    *   groups creates one FulfillmentOrder for each location. For each 
    *   OrderItemSummary, a FulfillmentOrderLineItem is created and assigned 
    *   to the corresponding FulfillmentOrder
    *   suppress reason: ignore
    * @param orderSummaryId Id of the OrderSummary
    * @param locationId Id of the Location
    * @param fulfillmentOrderType Type of the FulfillmentOrder (enum)
    * @return A list of Ids of the created FulfillmentOrders
    */
    ConnectApi.FulfillmentOrderOutputRepresentation createFulfillmentOrders(String orderSummaryId, String locationId, FulfillmentOrderType fulfillmentOrderType);

    /**
    * @description Create an invoice for a FulfillmentOrder that doesn’t have one
    * @param fulfillmentOrderId of the FulfillmentOrder
    * @return Id of the created Invoice
    */
    ConnectApi.FulfillmentOrderInvoiceOutputRepresentation createInvoice(String fulfillmentOrderId);

    /**
    * @description Cancel FulfillmentOrderLineItems from a FulfillmentOrder. 
    * This action doesn’t cancel the associated OrderItemSummaries, so reallocate
    *  the canceled quantities to a new FulfillmentOrder
    * @param fulfillmentOrderId Id of the FulfillmentOrder
    * @param lineItemIdToCancelQuantity Map<FulfillmentOrderLineItem.Id, FulfillmentOrderLineItem.Quantity/QuantityCancelled>
    * @return Wraps the base output
    */
    ConnectApi.FulfillmentOrderCancelLineItemsOutputRepresentation cancelFulfillmentOrderLineItems(String fulfillmentOrderId, Map<String, Decimal> lineItemIdToCancelQuantity);

    /**
    * @description Create FulfillmentOrders for multiple 
    *   OrderDeliveryGroups in a single request
    *   suppress reason: ignore
    * @param createFulfillmentOrderList Input contains
    *   LocationId, OrderSummaryId, FulfillmentType
    * @return List of responses for the individual 
    *   FulfillmentOrder creation attempts from a create
    *   multiple fulfillment orders request
    */
    ConnectApi.MultipleFulfillmentOrderOutputRepresentation createMultipleFulfillmentOrder(List<CreateMultipleFulfillmentOrderInput> createFulfillmentOrderList);

    /**
    * @description Create Invoices for multiple FulfillmentOrders 
    * @param fulfillmentOrderIds The list of FulfillmentOrder Ids
    * @return Ids of the created Invoices
    */
    ConnectApi.MultipleFulfillmentOrderInvoicesOutputRepresentation createMultipleInvoices(List<String> fulfillmentOrderIds);
}