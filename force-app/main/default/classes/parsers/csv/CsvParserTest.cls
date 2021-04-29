/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description Test class of Csv parser class
*/
@isTest
private class CsvParserTest {
    /**
    * @description Test method of CsvParser.parse
    */
    @isTest
    static void shouldParse() {
        String orderNumber = '001070';
        String isActive = 'true';
        String amount = '259.60';

        String csvInput = 'HEADER\n';
        csvInput += orderNumber + ',' + amount + ',' + isActive + '\n';
        csvInput += 'FOOTER';

        Test.startTest();
        String parsedText = CsvParser.parse(csvInput, '\n', ',', new ImportOrder().getFields(), true, true);
        Test.stopTest();

        List<ImportOrder> importOrders = (List<ImportOrder>)JSON.deserialize(parsedText, List<ImportOrder>.class);
        ImportOrder importOrder = importOrders[0];

        System.assert(importOrder.orderNumber.equals(orderNumber), 'Order number field is invalid');
        System.assert(importOrder.isActive.equals(isActive), 'Is active field is invalid');
        System.assert(importOrder.amount.equals(amount), 'Amount field is invalid');
    }

    private class ImportOrder {
        public String orderNumber;
        public String isActive;
        public String amount;

        /**
        * @description Test method of CsvParser.parse
        * @return Field list
        */
        public List<String> getFields()
        {
            return new List<String>
            {
                'OrderNumber',
                'Amount',
                'IsActive'
            };
        }
    }
}