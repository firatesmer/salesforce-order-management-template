/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 23/05/2021
* @description Object utils test class
*/
@isTest
private class ObjectUtilsTest {
    /**
    * @description Test method of ObjectUtils.getIdList
    */
    @isTest
    static void shouldGetIdList() {
        List<SalesChannel> salesChannelsToInsert = new List<SalesChannel>
        {
            new SalesChannel(SalesChannelName='Test 1'),
            new SalesChannel(SalesChannelName='Test 2')
        };

        Database.insert(salesChannelsToInsert, true);

        Set<Id> salesChannelIds = new Set<Id>();
        for (SalesChannel salesChannel : salesChannelsToInsert) {
            salesChannelIds.add(salesChannel.Id);
        }

        Test.startTest();
        Set<String> idList = ObjectUtils.getIdList(salesChannelsToInsert);
        Test.stopTest();

        System.assert(idList.size() == salesChannelsToInsert.size(), 'Id is missing');
    }
}