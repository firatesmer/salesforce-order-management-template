/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description OrderSummary/OrderItemSummary service class
*/
public with sharing class OrderSummaryService {
    /**
    * @description Checks wheter the order item is discountable
    * @param orderItemSummary OrderItemSummary
    * @return Discountable result
    */
    public static Boolean isOrderItemDiscountable(OrderItemSummary orderItemSummary) {
        if (orderItemSummary.Quantity != 0
        && orderItemSummary.QuantityReturnInitiated == orderItemSummary.QuantityReturned
        && orderItemSummary.QuantityAllocated == orderItemSummary.QuantityFulfilled
        && orderItemSummary.TotalAmtWithTax != 0) {
            return true;
        }

        return false;
    }

    /**
    * @description Get discountable OrderItemSummary based on given list
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
}