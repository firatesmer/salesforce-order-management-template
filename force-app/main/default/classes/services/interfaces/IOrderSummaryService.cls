/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 31/07/2021
* @description OrderSummary service class
*/
public interface IOrderSummaryService {
    /**
    * @description Checks whether the order item is discountable
    * @param orderItemSummary OrderItemSummary
    * @return Discountable result
    */
    Boolean isOrderItemDiscountable(OrderItemSummary orderItemSummary);

    /**
    * @description Checks whether the order item is cancelable
    * @param orderItemSummary OrderItemSummary
    * @return Cancelable result
    */
    Boolean isOrderItemCancelable(OrderItemSummary orderItemSummary);

    /**
    * @description Checks whether the order item is returnable
    * @param orderItemSummary OrderItemSummary
    * @return Returnable result
    */
    Boolean isOrderItemReturnable(OrderItemSummary orderItemSummary);

    /**
    * @description Gets discountable OrderItemSummaries based on given list
    * @param orderItemSummaries List of OrderItemSummary
    * @return OrderItemSummary list
    */
    List<OrderItemSummary> getDiscountableOrderItems(List<OrderItemSummary> orderItemSummaries);

    /**
    * @description Gets cancelable OrderItemSummaries based on given list
    * @param orderItemSummaries List of OrderItemSummary
    * @return OrderItemSummary list
    */
    List<OrderItemSummary> getCancelableOrderItems(List<OrderItemSummary> orderItemSummaries);

    /**
    * @description Gets returnable OrderItemSummaries based on given list
    * @param orderItemSummaries List of OrderItemSummary
    * @return OrderItemSummary list
    */
    List<OrderItemSummary> getReturnableOrderItems(List<OrderItemSummary> orderItemSummaries);

    /**
    * @description Builds input for previewCancel|submitCancel|previewReturn|submitReturn
    * @param orderItemSummaries List of OrderItemSummary
    * @param reason Change reason
    * @param shippingReductionFlag Reduction shipping
    * @return ConnectApi.ChangeInputRepresentation
    */
    ConnectApi.ChangeInputRepresentation buildChangeInput(List<OrderItemSummary> orderItemSummaries, OrderItemSummaryChangeReason reason, Boolean shippingReductionFlag);
}