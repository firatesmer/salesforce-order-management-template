/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description Test class of Xml parser document class
*/
@isTest
private class XmlParserDocumentTest {
    /**
    * @description Test method of XmlParser (initiate)
    */
    @isTest
    static void shouldInitiate() {
        String xmlString = '<warehouse><orders><order><customer>John Doe</customer><totalAmount>250.55</totalAmount><products><product>Product A</product></products><tax>39.95</tax></order><order><customer>Mr. Brown</customer><products><product>Product B</product><product>Product C</product><product>Product D</product><product>Product E</product></products><tax>37.88</tax></order></orders></warehouse>';

        XmlParserDocument xmlParser = new XmlParserDocument(xmlString);
        XmlParserDocument.Element document = xmlParser.ownerDocument();
        XmlParserDocument.Element orderElement = document.getElementByTagName('order');

        System.assert(xmlParser != null, 'Xml parser is null');
        System.assert(document != null, 'Xml document is null');
        System.assert(orderElement != null, 'Xml element is null');
    }
}