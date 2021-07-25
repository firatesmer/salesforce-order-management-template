/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 19/07/2021
* @description Model to use to create 
*   OrderItem in test classes
*/
@isTest
public class CreateTestOrderItemInput {
    /**
    * @description Product code of the item
    */
    public String productCode;

    /**
    * @description Quantity of the item
    */
    public Integer quantity;

    /**
    * @description Unit price of the item
    */
    public Double unitPrice;

    /**
    * @description Type of the item 
    *   DELIVERY CHARGE|ORDER PRODUCT
    */
    public OrderItemType type;

    /**
    * @description Tax amount for the item (optional)
    */
    public Double taxAmount;

    /**
    * @description Tax rate for the item (optional)
    */
    public Double taxRate;

    /**
    * @description Apply tax
    */
    public Boolean applyTax;

    /**
    * @description Set default values
    */
    public CreateTestOrderItemInput() {
        this.applyTax = false;
    }
}