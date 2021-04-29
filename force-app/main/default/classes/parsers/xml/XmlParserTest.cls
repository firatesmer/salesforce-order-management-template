/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description Test class of Xml parser class
*/
@isTest
private class XmlParserTest {
    static string xmlString = '<warehouse><orders><order><customer>John Doe</customer><totalAmount>250.55</totalAmount><products><product>Product A</product></products><price>39.95</price></order><order><customer>Mr. Brown</customer><products><product>Product C</product><product>Product D</product><product>Product E</product><product>Product F</product></products><price>37.88</price></order></orders></warehouse>';

    /**
    * @description Test method of XmlParser.serialize
    */
    @isTest
    static void shouldSerialize() {
        Source library = new Source();
        Location warehouse = new Location();
        Orders orders = new Orders();
        List<Order> order = new List<Order>();
        Order order1 = new Order();
        order1.customer = 'John Doe';
        Products products = new Products();
        List<String> productCodeList = new List<String>();
        productCodeList.add('Product A');
        products.product = productCodeList;
        order1.products = products;
        order.add(order1);
        orders.order = order;
        warehouse.orders = orders;
        library.warehouse = warehouse;
        
        Test.startTest();
        XmlParser parser = new XmlParser();
        String serializedWithDefaultOptions = parser.serialize(library);
        String serializedXmlWithOptions = parser.serialize(library, true, 'Root');
        Test.stopTest();

        System.assert(serializedWithDefaultOptions.containsIgnoreCase('<totalAmount></totalAmount>'), 'Invalid default serialize options');
        System.assert(!serializedXmlWithOptions.containsIgnoreCase('<totalAmount></totalAmount>'), 'Invalid <totalAmount>');
        System.assert(serializedXmlWithOptions.contains('<Root>'), '<Root> is missing');
        System.assert(serializedXmlWithOptions.contains('</Root>'), '</Root> is missing');
    }

    /**
    * @description Test method of XmlParser.deserialize
    */
    @isTest
    static void shouldDeserialize() {
        Test.startTest();
        XmlParser parser = new XmlParser();
        Source library = (Source)parser.deSerialize(xmlString, Source.class, new Set<String>{ 'product' });  
        Test.stopTest();
        
        System.assertEquals(2, library.warehouse.orders.order.size(), 'Should be 2 items');
        
        for(Order order: library.warehouse.orders.order) {            
            if(order.customer == 'John Doe') {
                System.assertEquals(1, order.products.product.size(), 'Should be 1 item');
            }
            else {
                System.assertEquals(4, order.products.product.size(), 'Should be 4 items');
            }
        }
    }
    
    /**
    * @description Test method of XmlParser.deserializeUntyped
    */
    @isTest
    static void shouldDeserializeUntyped() {
        XmlParser parser = new XmlParser();

        Test.startTest();
        Object o = parser.deserializeUntyped(xmlString, new Set<String>{ 'product' });          
        Map<String,Object> libraryMap1 = (Map<string,Object>)o;

        parser.resetDefaults();

        Object xmlToUnTypedObjectDefault = parser.deserializeUntyped(xmlString);
        Map<String,Object> libraryMap2 = (Map<string,Object>)xmlToUnTypedObjectDefault;

        Object xmlToUnTypedObjectWithOptions = parser.deserializeUntyped(xmlString,new Set<String>{ 'product' });
        Map<String,Object> libraryMap3 = (Map<string,Object>)xmlToUnTypedObjectWithOptions;
        Test.stopTest();

        System.assert(o instanceOf Map<String, Object>, 'Instance type of object is invalid');
        System.assert(libraryMap1.containsKey('warehouse'), 'Key is missing');
        System.assert(libraryMap2.containsKey('warehouse'), 'Key is missing');
        System.assert(libraryMap3.containsKey('warehouse'), 'Key is missing');        
    }
    
    /**
    * @description Test method of XmlParser.xmlToJson
    */
    @isTest
    static void shouldParseXmlToJson() {
        Test.startTest();
        XmlParser parser = new XmlParser();
        String jsonString = parser.xmlToJson(xmlString);      
        String jsonStringWithConvertAsArray = parser.xmlToJson(xmlString,new Set<String>{'product'}); 
        Test.stopTest();

        String expectedOutput = '{"warehouse":{"orders":{"order":[{"price":"39.95","products":{"product":"Product A"},"totalAmount":"250.55","customer":"John Doe"},{"price":"37.88","products":{"product":["Product C","Product D","Product E","Product F"]},"customer":"Mr. Brown"}]}}}';
       
        String expectedOutputWithArray ='{"warehouse":{"orders":{"order":[{"price":"39.95","products":{"product":["Product A"]},"totalAmount":"250.55","customer":"John Doe"},{"price":"37.88","products":{"product":["Product C","Product D","Product E","Product F"]},"customer":"Mr. Brown"}]}}}';

        System.assertEquals(expectedOutput, jsonString, 'Expected output is no match');
        System.assertEquals(expectedOutputWithArray, jsonStringWithConvertAsArray, 'Expected output is no match');
        System.assertNotEquals(expectedOutput, jsonStringWithConvertAsArray, 'Expected output is match');
    }
    
    /**
    * @description Test method of XmlParser.jsonToXml
    */
    @isTest
    static void shouldParseJsonToXml() {        
        String jsonString = '{"warehouse":{"orders":{"order":[{"price":"39.95","products":{"product":"Product A"},"totalAmount":"250.55","customer":null},{"price":"37.88","products":{"product":["Product C","Product D","Product E","Product F"]},"customer":"Mr. Brown"}]}}}';

        Test.startTest();
        XmlParser parser = new XmlParser();
        String convertedXmlString = parser.jsonToXml(jsonString);   
        string convertedStringWithOptions = parser.jsonToXml(jsonString, true);
        Test.stopTest();

        String expectedOutputWithDefaultOptions = '<warehouse><orders><order><price>39.95</price><products><product>Product A</product></products><totalAmount>250.55</totalAmount><customer></customer></order><order><price>37.88</price><products><product>Product C</product><product>Product D</product><product>Product E</product><product>Product F</product></products><customer>Mr. Brown</customer></order></orders></warehouse>';

        String expectedOutputWithOptions = '<warehouse><orders><order><price>39.95</price><products><product>Product A</product></products><totalAmount>250.55</totalAmount></order><order><price>37.88</price><products><product>Product C</product><product>Product D</product><product>Product E</product><product>Product F</product></products><customer>Mr. Brown</customer></order></orders></warehouse>';

        System.assertEquals(expectedOutputWithDefaultOptions, convertedXmlString, 'Expected output is no match');
        System.assertEquals(expectedOutputWithOptions, convertedStringWithOptions, 'Expected output is no match');
    }
    
    private class Source {        
        public Location warehouse;
    }

    private class Location {
        public Orders orders;
    }

    private class Orders {
        public List<Order> order;
    }

    private class Order {
        public String customer;
        public String totalAmount;
        public Products products;
        public String price;
    }
    
    private class Products {
        public List<String> product;
    }   
}