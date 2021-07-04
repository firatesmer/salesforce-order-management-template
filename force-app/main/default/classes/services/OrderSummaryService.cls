/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description OrderSummary/OrderItemSummary service class
*/
public with sharing class OrderSummaryService {
    /**
    * @description Checks whether the order item is discountable
    * @param orderItemSummary OrderItemSummary
    * @return Discountable result
    */
    public static Boolean isOrderItemDiscountable(OrderItemSummary orderItemSummary) {
        return orderItemSummary.Quantity != 0
            && orderItemSummary.QuantityReturnInitiated == orderItemSummary.QuantityReturned
            && orderItemSummary.QuantityAllocated == orderItemSummary.QuantityFulfilled
            && orderItemSummary.TotalAmtWithTax != 0;
    }

    /**
    * @description Checks whether the order item is cancelable
    * @param orderItemSummary OrderItemSummary
    * @return Cancelable result
    */
    public static Boolean isOrderItemCancelable(OrderItemSummary orderItemSummary) {
        return orderItemSummary.Type != OrderProductType.DELIVERY_CHARGE.toString()
            && orderItemSummary.QuantityAvailableToCancel > 0;
    }

    /**
    * @description Checks whether the order item is returnable
    * @param orderItemSummary OrderItemSummary
    * @return Returnable result
    */
    public static Boolean isOrderItemReturnable(OrderItemSummary orderItemSummary) {
        return orderItemSummary.Type != OrderProductType.DELIVERY_CHARGE.toString()
            && orderItemSummary.QuantityAvailableToReturn > 0;
    }

    /**
    * @description Gets discountable OrderItemSummaries based on given list
    * @param orderItemSummaries List of OrderItemSummary
    * @return OrderItemSummary list
    */
    public static List<OrderItemSummary> getDiscountableOrderItems(List<OrderItemSummary> orderItemSummaries) {
        List<OrderItemSummary> discountableOrderItems = new List<OrderItemSummary>();

        for (OrderItemSummary orderItemSummary : orderItemSummaries) {
            Boolean isOrderItemDiscountable = isOrderItemDiscountable(orderItemSummary);
            
            if (isOrderItemDiscountable) {
                discountableOrderItems.add(orderItemSummary);
            }
        }

        return discountableOrderItems;
    }

    /**
    * @description Gets cancelable OrderItemSummaries based on given list
    * @param orderItemSummaries List of OrderItemSummary
    * @return OrderItemSummary list
    */
    public static List<OrderItemSummary> getCancelableOrderItems(List<OrderItemSummary> orderItemSummaries) {
        List<OrderItemSummary> cancelableOrderItems = new List<OrderItemSummary>();

        for (OrderItemSummary orderItemSummary : orderItemSummaries) {
            Boolean isOrderItemCancelable = isOrderItemCancelable(orderItemSummary);
            
            if (isOrderItemCancelable) {
                cancelableOrderItems.add(orderItemSummary);
            }
        }

        return cancelableOrderItems;
    }

    /**
    * @description Gets returnable OrderItemSummaries based on given list
    * @param orderItemSummaries List of OrderItemSummary
    * @return OrderItemSummary list
    */
    public static List<OrderItemSummary> getReturnableOrderItems(List<OrderItemSummary> orderItemSummaries) {
        List<OrderItemSummary> returnableOrderItems = new List<OrderItemSummary>();

        for (OrderItemSummary orderItemSummary : orderItemSummaries) {
            Boolean isOrderItemReturnable = isOrderItemReturnable(orderItemSummary);
            
            if (isOrderItemReturnable) {
                returnableOrderItems.add(orderItemSummary);
            }
        }

        return returnableOrderItems;
    }

    /**
    * @description Builds input for previewCancel|submitCancel|previewReturn|submitReturn
    * @param orderItemSummaries List of OrderItemSummary
    * @param reason Change reason
    * @param shippingReductionFlag Reduction shipping
    * @return ConnectApi.ChangeInputRepresentation
    */
    public static ConnectApi.ChangeInputRepresentation buildChangeInput(List<OrderItemSummary> orderItemSummaries, String reason, Boolean shippingReductionFlag) {
        ConnectApi.ChangeInputRepresentation changeInput = new ConnectApi.ChangeInputRepresentation();
        List<ConnectApi.ChangeItemInputRepresentation> changeItemInputList = new List<ConnectApi.ChangeItemInputRepresentation>();

        for (OrderItemSummary orderItemSummary : orderItemSummaries) {
            ConnectApi.ChangeItemInputRepresentation changeItemInput = new ConnectApi.ChangeItemInputRepresentation();
            changeItemInput.orderItemSummaryId = orderItemSummary.Id;
            changeItemInput.quantity = orderItemSummary.Quantity;
            changeItemInput.reason = reason;
            changeItemInput.shippingReductionFlag = shippingReductionFlag;
            changeItemInputList.add(changeItemInput);
        }

        changeInput.changeItems = changeItemInputList;
        return changeInput;
    }
}