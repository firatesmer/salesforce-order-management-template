/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description Test data factory class
*/
@isTest
public class TestDataFactory {
    /**
    * @description Returns default success Http response body
    * @return Http response plain text
    */
    public static string getDefaultRestSuccessMockResponseBody() {
        return '{ "isSuccess":true }';
    }

    /**
    * @description Returns default fail Http response body
    * @return Http response plain text
    */
    public static string getDefaultRestFailMockResponseBody() {
        return '{ "isSuccess":false }';
    }

    /**
    * @description Creates Contact object
    * @param lastName Contact last name
    * @return Contact
    */
    public static Contact createContact(String lastName) {
        Contact contact = new Contact();
        contact.LastName = lastname;
        return contact;
    }

    /**
    * @description Creates product
    * @param productCode Product code
    * @return Product2
    */
    public static Product2 createProduct(String productCode) {
        Product2 product = new Product2();
        product.Name = Constants.TEST;
        product.ProductCode = productCode;
        return product;
    }

    /**
    * @description Creates pricebook entry
    * @param unitPrice Unit price
    * @param productId Product Id (createProduct)
    * @return PricebookEntry
    */
    public static PricebookEntry createPricebookEntry(Decimal unitPrice, Id productId) {
        PricebookEntry priceBookEntry = new PriceBookEntry();
        priceBookEntry.UnitPrice = unitPrice;
        priceBookEntry.Pricebook2Id = Test.getStandardPricebookId();
        priceBookEntry.Product2Id = productId;
        return priceBookEntry;
    }

    /**
    * @description Creates account
    * @param firstName First name of the account
    * @param lastName Last name of the account
    * @param email Email address of the account
    * @return Account
    */
    public static Account createAccount(String firstName, String lastName, String email) {
        Account account = new Account();
        account.FirstName = firstName;
        account.LastName = lastName;
        account.PersonEmail = email;

        List<RecordType> personAccountRecordTypes = [SELECT Id FROM RecordType WHERE IsPersonType = true AND IsActive = true AND SobjectType = 'Account'];
        if (!personAccountRecordTypes.isEmpty()) {
            account.RecordTypeId = personAccountRecordTypes[0].Id;
        }

        return account;
    }

    /**
    * @description Creates contract
    * @param accountId Account Id (createAccount)
    * @return Contract
    */
    public static Contract createContract(Id accountId) {
        Contract contract = new Contract();
        contract.AccountId = accountId;
        contract.Status = Constants.DRAFT;
        return contract;
    }

    /**
    * @description Creates saleschannel
    * @param saleschannelName Saleschannel name
    * @return Saleschannel
    */
    public static Saleschannel createSaleschannel(string saleschannelName) {
        Saleschannel saleschannel = new Saleschannel();
        saleschannel.SaleschannelName = saleschannelName;
        return saleschannel;
    }

    /**
    * @description Creates order
    * @param accountId Account Id (createAccount)
    * @param contractId Contract Id (createContract)
    * @param saleschannelId Saleschannel Id (createSaleschannel)
    * @return Order
    */
    public static Order createOrder(Id accountId, Id contractId, Id saleschannelId) {
        Order order = new Order();
        order.AccountId = accountId;
        order.Pricebook2Id = Test.getStandardPricebookId();
        order.EffectiveDate = Date.today();
        order.Status = Constants.DRAFT;
        order.ContractId = contractId;
        order.SalesChannelId = saleschannelId;
        return order;
    }

    /**
    * @description Creates order delivery method
    * @return OrderDeliveryMethod
    */
    public static OrderDeliveryMethod createOrderDeliveryMethod() {
        OrderDeliveryMethod orderDeliveryMethod = new OrderDeliveryMethod();
        orderDeliveryMethod.Name = Constants.TEST;
        orderDeliveryMethod.ReferenceNumber = Constants.TEST;
        return orderDeliveryMethod;
    }

    /**
    * @description Creates order
    * @param orderId Order Id (createOrder)
    * @param orderDeliveryMethodId Order delivery method Id (createOrderDeliveryMethod)
    * @return OrderDeliveryGroup
    */
    public static OrderDeliveryGroup createOrderDeliveryGroup(Id orderId, Id orderDeliveryMethodId) {
        OrderDeliveryGroup orderDeliveryGroup = new OrderDeliveryGroup();
        orderDeliveryGroup.OrderId = orderId;
        orderDeliveryGroup.OrderDeliveryMethodId = orderDeliveryMethodId;
        orderDeliveryGroup.DeliverToName = Constants.TEST;
        orderDeliveryGroup.DeliverToCountry = Constants.TEST;
        orderDeliveryGroup.DeliverToCity = Constants.TEST;
        orderDeliveryGroup.DeliverToPostalCode = Constants.TEST;
        orderDeliveryGroup.DeliverToStreet = Constants.TEST;
        return orderDeliveryGroup;
    }

    /**
    * @description Creates order
    *   suppress reason: ignore
    * @param orderId Order Id (createOrder)
    * @param productId Product Id (createProduct)
    * @param priceBookEntryId Pricebook entry Id (createPricebookEntry)
    * @param unitPrice Unit price
    * @param quantity Quantity
    * @param orderDeliveryGroupId Order delivery group Id (createOrderDeliveryGroup)
    * @param orderProductType Order item type
    * @return OrderDeliveryGroup
    */
    @SuppressWarnings('PMD.ExcessiveParameterList')
    public static OrderItem createOrderItem(Id orderId, Id productId, Id priceBookEntryId, Decimal unitPrice, Integer quantity, Id orderDeliveryGroupId, String orderProductType) {
        OrderItem item = new OrderItem();
        item.OrderId = orderId;
        item.Product2Id = productId;
        item.PricebookentryId = priceBookEntryId;
        item.UnitPrice = unitPrice;
        item.Quantity = quantity;
        item.Type = orderProductType;
        item.OrderDeliveryGroupId = orderDeliveryGroupId;
        item.TotalLineAmount = unitPrice * quantity;
        return item;
    }

    /**
    * @description Creates location
    * @param name Location name
    * @param locationType Location type (LocationType enum)
    * @return Location
    */
    public static Schema.Location createLocation(String name, String locationType) {
        Schema.Location location = new Schema.Location();
        location.Name = name;
        location.LocationType = locationType;
        return location;
    }

    /**
    * @description Creates order item tax
    *   suppress reason: ignore
    * @param name Name
    * @param orderItemId Order item Id (createOrderItem)
    * @param type Tax type
    * @param amount Tax amount
    * @param rate Tax rate
    * @return OrderItemTaxLineItem
    */
    @SuppressWarnings('PMD.ExcessiveParameterList')
    public static OrderItemTaxLineItem createOrderItemTaxLineItem(String name, Id orderItemId, String type, Double amount, Double rate) {
        OrderItemTaxLineItem itemTax = new OrderItemTaxLineItem();
        itemTax.Name = name;
        itemTax.OrderItemId = orderItemId;
        itemTax.Type = type;
        itemTax.Amount = amount;
        itemTax.Rate = rate;
        itemTax.TaxEffectiveDate = Date.today();
        return itemTax;
    }

    /**
    * @description Creates payment group
    * @param sourceObjectId Id of object
    * @return PaymentGroup
    */
    public static PaymentGroup createPaymentGroup(String sourceObjectId) {
        PaymentGroup paymentGroup = new PaymentGroup();
        paymentGroup.SourceObjectId = sourceObjectId;
        return paymentGroup; 
    }

    /**
    * @description Creates payment authorization
    * @param amount Payment amount
    * @param paymentGroupId Id of the PaymentGroup (createPaymentGroup)
    * @param paymentMethodId Id of the PaymentMethod (createPaymentMethod)
    * @return PaymentAuthorization
    */
    public static PaymentAuthorization createPaymentAuthorization(Double amount, String paymentGroupId, String paymentMethodId) {
        PaymentAuthorization paymentAuthorization = new PaymentAuthorization();
        paymentAuthorization.Amount = amount;
        paymentAuthorization.Status = Constants.PROCESSED;
        paymentAuthorization.ProcessingMode = Constants.EXTERNAL;
        paymentAuthorization.PaymentMethodId = paymentMethodId;
        paymentAuthorization.PaymentGroupId = paymentGroupId;
        return paymentAuthorization;
    }

    /**
    * @description Creates order and related objects
    * @param orderItemList CreateOrderItem list
    * @param locationId Location id
    * @return Order
    */
    public static Order createOrderAndRelatedObjects(List<CreateOrderItem> orderItemList, String locationId) {
        Double subTotal = 0; 

        // Product2
        Map<String, Product2> codeToProduct = new Map<String, Product2>();
        for (CreateOrderItem orderItem : orderItemList) {
            codeToProduct.put(orderItem.productCode, createProduct(orderItem.productCode));
        }
        insert codeToProduct.values();

        // PricebookEntry
        Map<String, PricebookEntry> codeToPricebookEntry = new Map<String, PricebookEntry>();
        for (CreateOrderItem orderItem : orderItemList) {
            Product2 product = codeToProduct.get(orderItem.productCode);
            codeToPricebookEntry.put(orderItem.productCode, createPricebookEntry(orderItem.unitPrice, product.Id));
            subTotal += (Double)(orderItem.unitPrice * orderItem.quantity);
        }
        insert codeToPricebookEntry.values();

        // Account
        Account account = createAccount(Constants.TEST, Constants.TEST, 'joe@doe.com');
        insert account;

        // Contract
        Contract contract = createContract(account.Id);
        insert contract;
        contract.Status = Constants.ACTIVATED;
        update contract;

        // Saleschannel
        Saleschannel saleschannel = createSaleschannel(Constants.TEST);
        insert saleschannel;

        // Order
        Order order = createOrder(account.Id, contract.Id, saleschannel.Id);
        insert order;
        
        // OrderDeliveryMethod
        OrderDeliveryMethod orderDeliveryMethod = createOrderDeliveryMethod();
        insert orderDeliveryMethod;

        // OrderDeliveryGroup
        OrderDeliveryGroup orderDeliveryGroup = createOrderDeliveryGroup(order.Id, orderDeliveryMethod.Id);
        insert orderDeliveryGroup;

        // OrderItem
        Map<String, OrderItem> codeToOrderItem = new Map<String, OrderItem>();
        for (CreateOrderItem orderItem : orderItemList) {
            Product2 product = codeToProduct.get(orderItem.productCode);
            PricebookEntry pricebookEntry = codeToPricebookEntry.get(orderItem.productCode);

            OrderItem standardOrderItem = createOrderItem(order.Id, product.Id, pricebookEntry.Id, orderItem.unitPrice, 
                orderItem.quantity, orderDeliveryGroup.Id, orderItem.type.toString());
            codeToOrderItem.put(orderItem.productCode, standardOrderItem);    
        }
        insert codeToOrderItem.values();

        // OrderItemTaxLineItem
        List<OrderItemTaxLineItem> orderItemTaxLineItems = new List<OrderItemTaxLineItem>();
        for (CreateOrderItem orderItem : orderItemList) {
            if (orderItem.applyTax) {
                OrderItem standardOrderItem = codeToOrderItem.get(orderItem.productCode);

                OrderItemTaxLineItem orderItemTaxLineItem = createOrderItemTaxLineItem(Constants.TEST, standardOrderItem.Id, 
                    Constants.ESTIMATED, orderItem.taxAmount, orderItem.taxRate);
                orderItemTaxLineItems.add(orderItemTaxLineItem);
            }
        }     
        if (!orderItemTaxLineItems.isEmpty()) {
            insert orderItemTaxLineItems;
        }

        // CardPaymentMethod
        CardPaymentMethod paymentMethod = createCardPaymentMethod(account);
        insert paymentMethod;

        // PaymentGroup
        PaymentGroup paymentGroup = TestDataFactory.createPaymentGroup(order.Id);
        insert paymentGroup;

        // PaymentAuthorization 
        PaymentAuthorization paymentAuthorization = TestDataFactory.createPaymentAuthorization(subTotal, paymentGroup.Id, paymentMethod.Id);
        insert paymentAuthorization;

        order.Status = Constants.ACTIVATED;
        update order;

        return order;
    }

    /**
     * @description Creates CardPaymentMethod
     * @param account Account
     * @return CardPaymentMethod
     */
    public static CardPaymentMethod createCardPaymentMethod(Account account) {
        CardPaymentMethod paymentMethod = new CardPaymentMethod();
        paymentMethod.CardType = CardPaymentMethodType.VISA.toString();
        paymentMethod.CardHolderName = String.format('{0} {1}', new List<String>{ account.FirstName, account.LastName });
        paymentMethod.ExpiryYear = System.today().year() + 1;
        paymentMethod.ExpiryMonth = 1;
        paymentMethod.CardCategory = 'CreditCard';
        paymentMethod.Status = CardPaymentMethodStatus.ACTIVE.toString();
        paymentMethod.AccountId = account.Id;
        paymentMethod.ProcessingMode = Constants.EXTERNAL;
        paymentMethod.PaymentGatewayId = [SELECT Id FROM PaymentGateway LIMIT 1].Id;
        return paymentMethod;
    }


    /**
    * @description Model to use to create 
    *   OrderItem in test classes
    */
    public class CreateOrderItem {
        /**
        * @description Set default values
        */
        public CreateOrderItem() {
            this.applyTax = false;
        }

        /**
        * @description Product code of the item
        */
        public String productCode { get; set; }

        /**
        * @description Quantity of the item
        */
        public Integer quantity { get; set; }

        /**
        * @description Unit price of the item
        */
        public Double unitPrice { get; set; }

        /**
        * @description Type of the item 
        *   DELIVERY CHARGE|ORDER PRODUCT
        */
        public OrderProductType type { get; set; }

        /**
        * @description Tax amount for the item (optional)
        */
        public Double taxAmount { get; set; }

        /**
        * @description Tax rate for the item (optional)
        */
        public Double taxRate { get; set; }

        /**
        * @description Apply tax
        */
        public Boolean applyTax { get; set; }
    }
}