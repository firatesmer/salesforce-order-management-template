/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description Sandbox preparation class
*   suppress reason: Salesforce limitation
*/
@SuppressWarnings('PMD.AvoidGlobalModifier')
public without sharing class OrderManagementSetup {
    /**
    * @description Calls all methods related data creation
    */
    public static void execute() {
        // Savepoint point = Database.setSavepoint();

        try {
            insertPaymentGatewayAndProvider();

            insertOrderDeliveryMethods();

            insertProducts();
    
            insertAccount();
    
            insertSalesChannel();

            insertLocation();
        } catch (Exception ex) {
            // Database.rollback(point);
            System.debug(LoggingLevel.ERROR, String.format('Error - Line: {0} - Message {1}', new List<String>{ String.valueof(ex.getLineNumber()), ex.getMessage() }));
        }
    }

    /**
    * @description Inserts default SFCC shipping methods
    *   as OrderDeliveryMethod objects
    */
    public static void insertOrderDeliveryMethods() {
        Map<String, String> shippingMethods = new Map<String, String>
        {
            '001' => 'Ground',
            '002' => '2-Day Express',
            '003' => 'Overnight',
            '004' => 'Super Saver',
            '005' => 'Store Pickup',
            '012' => 'Express',
            '021' => 'USPS',
            'EUR001' => 'EUR Ground',
            'EUR002' => 'EUR 2-Day Express',
            'EUR003' => 'EUR Overnight',
            'EUR004' => 'EUR Super Saver',
            'EUR005' => 'EUR Store Pickup'
        };
        
        // order delivery method products
        Map<String, Product2> referenceToProductMap = new Map<String, Product2>();
        for(String shippingMethodKey : shippingMethods.keySet()) {
            String shippingMethodValue = shippingMethods.get(shippingMethodKey);
        
            Product2 product = new Product2();
            product.Name = shippingMethodValue;
            product.ProductCode = shippingMethodKey;
            product.IsActive = true;
            referenceToProductMap.put(shippingMethodKey, product);
        }
        Database.insert(referenceToProductMap.values(), true);
        
        // PricebookEntry (of Product)
        Pricebook2 pricebook = [SELECT IsActive FROM Pricebook2 WHERE IsStandard = true WITH SECURITY_ENFORCED LIMIT 1];

        if (!pricebook.IsActive) {
            pricebook.IsActive = true;
            Database.update(pricebook);
        }

        List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();
        for(String shippingMethodKey : shippingMethods.keySet()) {
            PricebookEntry pricebookEntry = new PricebookEntry();
            pricebookEntry.Pricebook2Id = pricebook.Id;
            pricebookEntry.UnitPrice = 0;
            pricebookEntry.Product2Id = referenceToProductMap.get(shippingMethodKey).Id;
            pricebookEntry.IsActive = true;
            pricebookEntries.add(pricebookEntry);
        }
        Database.insert(pricebookEntries, true);
        
        // OrderDeliveryMethod
        List<OrderDeliveryMethod> orderDeliveryMethods = new List<OrderDeliveryMethod>();
        for(String shippingMethodKey : shippingMethods.keySet()) {
            String shippingMethodValue = shippingMethods.get(shippingMethodKey);
        
            OrderDeliveryMethod orderDeliveryMethod = new OrderDeliveryMethod();
            orderDeliveryMethod.Name = shippingMethodValue;
            orderDeliveryMethod.ReferenceNumber = shippingMethodKey;
            orderDeliveryMethod.ProductId = referenceToProductMap.get(shippingMethodKey).Id;
            orderDeliveryMethod.IsActive = true;
            orderDeliveryMethods.add(orderDeliveryMethod);
        }

        Database.insert(orderDeliveryMethods, true);
    }

    /**
    * @description Inserts sample Products and related objects
    */
    public static void insertProducts() {
        Map<String, String> products = new Map<String, String>
        {
            '001' => 'PRODUCT A',
            '002' => 'PRODUCT B',
            '003' => 'PRODUCT C',
            '004' => 'PRODUCT D',
            '005' => 'PRODUCT E',
            'S01' => 'SHIPPING A'
        };

        // Product
        Map<String, Product2> referenceToProductMap = new Map<String, Product2>();
        for(String shippingMethodKey : products.keySet()) {
            String shippingMethodValue = products.get(shippingMethodKey);

            Product2 product = new Product2();
            product.Name = shippingMethodValue;
            product.ProductCode = shippingMethodKey;
            product.IsActive = true;
            referenceToProductMap.put(shippingMethodKey, product);
        }
        Database.insert(referenceToProductMap.values(), true);

        Pricebook2 pricebook = [SELECT Id FROM Pricebook2 WHERE IsActive = true and IsStandard = true WITH SECURITY_ENFORCED];

        // PricebookEntry (of Product)
        List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();
        for(String shippingMethodKey : products.keySet()) {
            PricebookEntry pricebookEntry = new PricebookEntry();
            pricebookEntry.Pricebook2Id = pricebook.Id;
            pricebookEntry.UnitPrice = 0;
            pricebookEntry.Product2Id = referenceToProductMap.get(shippingMethodKey).Id;
            pricebookEntry.IsActive = true;
            pricebookEntries.add(pricebookEntry);
        }
        Database.insert(pricebookEntries, true);
    }

    /**
    * @description Inserts PaymentGateway and PaymentGatewayProvider
    *   execute this method last to prevent 'uncommitted work' issue
    */
    public static void insertPaymentGatewayAndProvider() {
        String salesforceUrl = URL.getSalesforceBaseUrl().toExternalForm();

        insertPaymentGateway(salesforceUrl);
        insertPaymentGatewayProvider(salesforceUrl);
    }

    /**
    * @description Inserts PaymentGateway
    * @param salesforceUrl Sandbox Url
    *   suppress reason: ignore
    */
    @SuppressWarnings('PMD.ApexSuggestUsingNamedCred')
    public static void insertPaymentGateway(String salesforceUrl) {
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint(String.format('{0}{1}', new List<String>{ salesforceUrl, '/services/data/v49.0/composite' }));
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', String.format('Bearer {0}', new List<String>{ UserInfo.getSessionId() }));
        
        String payload = '{"allOrNone":true,"compositeRequest":[{"method":"GET","url":"/services/data/v49.0/query/?q=SELECT+Id+FROM+ApexClass+WHERE+Name+=+\'SalesforceAdapter\'","referenceId":"refPayeezyAdapter"},{"method":"POST","url":"/services/data/v49.0/sobjects/PaymentGatewayProvider","referenceId":"refPaymentGatewayProvider","body":{"ApexAdapterId":"@{refPayeezyAdapter.records[0].Id}","DeveloperName":"TestPaymentGatewayProvider","MasterLabel":"TestPaymentGatewayProvider"}}]}';
        
        request.setBody(payload);
        new Http().send(request);
    }

    /**
    * @description Inserts PaymentGatewayProvider
    * @param salesforceUrl Sandbox Url
    *   suppress reason: ignore
    */
    @SuppressWarnings('PMD.ApexSuggestUsingNamedCred')
    public static void insertPaymentGatewayProvider(String salesforceUrl) {
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint(String.format('{0}{1}', new List<String>{ salesforceUrl, '/services/data/v49.0/composite' }));
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', String.format('Bearer {0}', new List<String>{ UserInfo.getSessionId() }));
        
        String payload = '{"allOrNone":true,"compositeRequest":[{"method":"GET","url":"/services/data/v49.0/query/?q=SELECT+Id+FROM+PaymentGatewayProvider","referenceId":"refPaymentGatewayProvider"},{"method":"GET","url":"/services/data/v49.0/query/?q=SELECT+Id+FROM+NamedCredential+WHERE+MasterLabel+=+\'TestNamedCredential\'","referenceId":"refNamedCredential"},{"method":"POST","url":"/services/data/v49.0/sobjects/PaymentGateway","referenceId":"refPaymentGateway","body":{"MerchantCredentialId":"@{refNamedCredential.records[0].Id}","PaymentGatewayName":"TestPaymentGateway","PaymentGatewayProviderId":"@{refPaymentGatewayProvider.records[0].Id}","Status":"Active","ExternalReference":"BASIC_CREDIT"}}]}';
        
        request.setBody(payload);
        new Http().send(request);
    }

    /**
    * @description Insert a sample Account
    */
    public static void insertAccount() {
        Account newAccount = new Account();
        newAccount.FirstName = UserInfo.getFirstName();
        newAccount.LastName = UserInfo.getLastName();
        newAccount.PersonEmail = UserInfo.getUserEmail();
        Database.insert(newAccount);
    }

    /**
    * @description Insert a sample SalesChannel
    */
    public static void insertSalesChannel() {
        SalesChannel newSaleschannel = new SalesChannel();
        newSaleschannel.SalesChannelName = 'Test Sales Channel';
        newSaleschannel.ExternalChannelNumber = 'Test_Sales_Channel';
        Database.insert(newSaleschannel);
    }

    /**
    * @description Insert a sample Location (Warehouse type)
    */
    public static void insertLocation() {
        Schema.Location newLocation = new Schema.Location();
        newLocation.Name = 'Warehouse';
        newLocation.LocationType = 'Warehouse';
        Database.insert(newLocation);
    }
}