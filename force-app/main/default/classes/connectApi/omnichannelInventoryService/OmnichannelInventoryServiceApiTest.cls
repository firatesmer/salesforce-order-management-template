/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 19/07/2021
* @description OmnichannelInventoryServiceApi test class
*/
@isTest
private class OmnichannelInventoryServiceApiTest {
    /**
    * @description Test method of 
    *   OmnichannelInventoryServiceApi.createReservation
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldCreateReservation() {
        ConnectApi.OCICreateReservationSingleInputRepresentation singleReservationInput  = new ConnectApi.OCICreateReservationSingleInputRepresentation();
        singleReservationInput.locationGroupIdentifier = 'TEST_LOCATION_GROUP';
        singleReservationInput.quantity = 1;
        singleReservationInput.stockKeepingUnit = '001';

        ConnectApi.OCICreateReservationInputRepresentation input = new ConnectApi.OCICreateReservationInputRepresentation();
        input.actionRequestId = 'requestId';
        input.allowPartialReservations = true;
        input.expirationSeconds = 20;
        input.externalRefId = 'externalRefId';
        input.reservationTime = DateTime.now().format('YYYY-MM-dd\'T\'HH:mm:ss\'Z\'');
        input.createRecords = new List<ConnectApi.OCICreateReservationSingleInputRepresentation>{ singleReservationInput };

        Test.startTest();
        ConnectApi.OCICreateReservationOutputRepresentation output = new OmnichannelInventoryServiceApi().createReservation(input);
        Test.stopTest();

        System.assert(output.success, 'Create reservation action is failed');
    }

    /**
    * @description Test method of 
    *   OmnichannelInventoryServiceApi.fulfillReservation
    *   suppress reason: ConnectApi requires SeeAllData=true annotation
    */
    @suppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
    @isTest(SeeAllData=true)
    static void shouldFulfillReservation() {
        ConnectApi.OCIFulfillReservationSingleInputRepresentation singleFulfillInput = new ConnectApi.OCIFulfillReservationSingleInputRepresentation();
        singleFulfillInput.actionRequestId = 'requestId';
        singleFulfillInput.externalRefId = 'externalRefId';
        singleFulfillInput.locationIdentifier = 'TEST_LOCATION';
        singleFulfillInput.quantity = 1;
        singleFulfillInput.stockKeepingUnit = '001';

        ConnectApi.OCIFulfillReservationInputRepresentation input = new ConnectApi.OCIFulfillReservationInputRepresentation();
        input.fulfillmentRecords = new List<ConnectApi.OCIFulfillReservationSingleInputRepresentation> { singleFulfillInput };

        Test.startTest();
        ConnectApi.OCIFulfillReservationOutputRepresentation output = new OmnichannelInventoryServiceApi().fulfillReservation(input);
        Test.stopTest();

        System.assert(output.success, 'Fulfill reservation action is failed');
    }
}