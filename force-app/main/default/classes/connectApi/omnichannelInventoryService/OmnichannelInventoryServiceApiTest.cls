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
    */
    @isTest
    static void shouldCreateReservation() {
        ConnectApi.OCICreateReservationSingleInputRepresentation singleReservationInput  = new ConnectApi.OCICreateReservationSingleInputRepresentation();
        singleReservationInput.locationGroupIdentifier = 'TEST_LOCATION_GROUP';
        singleReservationInput.quantity = 1;
        singleReservationInput.stockKeepingUnit = '001';

        ConnectApi.OCICreateReservationInputRepresentation input = new ConnectApi.OCICreateReservationInputRepresentation();
        input.actionRequestId = 'requestId';
        input.allowPartialReservations = true;
        input.expirationSeconds = 20;
        input.externalRefId = 'externalRef_Id';
        input.reservationTime = DateTime.now().format('YYYY-MM-dd\'T\'HH:mm:ss\'Z\'');
        input.createRecords = new List<ConnectApi.OCICreateReservationSingleInputRepresentation>{ singleReservationInput };

        IOmnichannelInventoryServiceApi api = (IOmnichannelInventoryServiceApi)Application.ConnectApi.newInstance(IOmnichannelInventoryServiceApi.class);

        Test.startTest();
        ConnectApi.OCICreateReservationOutputRepresentation output = api.createReservation(input);
        Test.stopTest();

        System.assert(output.success, 'Create reservation action is failed');
    }

    /**
    * @description Test method of 
    *   OmnichannelInventoryServiceApi.fulfillReservation
    */
    @isTest
    static void shouldFulfillReservation() {
        ConnectApi.OCIFulfillReservationSingleInputRepresentation singleFulfillInput = new ConnectApi.OCIFulfillReservationSingleInputRepresentation();
        singleFulfillInput.actionRequestId = 'request_Id';
        singleFulfillInput.externalRefId = 'externalRef_Id';
        singleFulfillInput.locationIdentifier = 'TEST_LOCATION';
        singleFulfillInput.quantity = 1;
        singleFulfillInput.stockKeepingUnit = '001';

        ConnectApi.OCIFulfillReservationInputRepresentation input = new ConnectApi.OCIFulfillReservationInputRepresentation();
        input.fulfillmentRecords = new List<ConnectApi.OCIFulfillReservationSingleInputRepresentation> { singleFulfillInput };

        IOmnichannelInventoryServiceApi api = (IOmnichannelInventoryServiceApi)Application.ConnectApi.newInstance(IOmnichannelInventoryServiceApi.class);

        Test.startTest();
        ConnectApi.OCIFulfillReservationOutputRepresentation output = api.fulfillReservation(input);
        Test.stopTest();

        System.assert(output.success, 'Fulfill reservation action is failed');
    }

    /**
    * @description Test method of 
    *   OmnichannelInventoryServiceApi.getInventoryAvailability
    */
    @isTest
    static void shouldGetInventoryAvailability() {
        ConnectApi.OCIGetInventoryAvailabilityInputRepresentation input = new ConnectApi.OCIGetInventoryAvailabilityInputRepresentation();
        input.locationIdentifiers = new List<String>{ 'location_Id' };
        input.stockKeepingUnit = '001';
        input.useCache = false;

        IOmnichannelInventoryServiceApi api = (IOmnichannelInventoryServiceApi)Application.ConnectApi.newInstance(IOmnichannelInventoryServiceApi.class);

        Test.startTest();
        ConnectApi.OCIGetInventoryAvailabilityOutputRepresentation output = api.getInventoryAvailability(input);
        Test.stopTest();

        System.assert(output.success, 'Get inventory availability action is failed');
    }

    /**
    * @description Test method of 
    *   OmnichannelInventoryServiceApi.getInventoryAvailabilityUploadStatus
    */
    @isTest
    static void shouldGetInventoryAvailabilityUploadStatus() {
        String uploadId = 'upload_id';

        IOmnichannelInventoryServiceApi api = (IOmnichannelInventoryServiceApi)Application.ConnectApi.newInstance(IOmnichannelInventoryServiceApi.class);

        Test.startTest();
        ConnectApi.OCIUploadInventoryAvailabilityStatusOutputRepresentation output = api.getInventoryAvailabilityUploadStatus(uploadId);
        Test.stopTest();

        System.assert(output.success, 'Get inventory availability upload status action is failed');
    }

    /**
    * @description Test method of 
    *   OmnichannelInventoryServiceApi.getPublishLocationStructureStatus
    */
    @isTest
    static void shouldGetPublishLocationStructureStatus() {
        String uploadId = 'upload_id';

        IOmnichannelInventoryServiceApi api = (IOmnichannelInventoryServiceApi)Application.ConnectApi.newInstance(IOmnichannelInventoryServiceApi.class);

        Test.startTest();
        ConnectApi.OCIPublishLocationStructureStatusOutputRepresentation output = api.getPublishLocationStructureStatus(uploadId);
        Test.stopTest();

        System.assert(output.success, 'Get publish location structure action is failed');
    }

    /**
    * @description Test method of 
    *   OmnichannelInventoryServiceApi.publishLocationStructure
    */
    @isTest
    static void shouldPublishLocationStructure() {
        IOmnichannelInventoryServiceApi api = (IOmnichannelInventoryServiceApi)Application.ConnectApi.newInstance(IOmnichannelInventoryServiceApi.class);

        Test.startTest();
        ConnectApi.OCIPublishLocationStructureOutputRepresentation output = api.publishLocationStructure();
        Test.stopTest();

        System.assert(output.success, 'Publish location structure action is failed');
    }

    /**
    * @description Test method of 
    *   OmnichannelInventoryServiceApi.releaseReservation
    */
    @isTest
    static void shouldReleaseReservation() {
        List<ConnectApi.OCIReleaseReservationSingleInputRepresentation> inputs = new List<ConnectApi.OCIReleaseReservationSingleInputRepresentation>();
        ConnectApi.OCIReleaseReservationSingleInputRepresentation input = new ConnectApi.OCIReleaseReservationSingleInputRepresentation();
        input.actionRequestId = 'actionRequest_Id';
        input.externalRefId = 'externalRef_Id';
        input.locationIdentifier = 'location_id';
        input.quantity = 1;
        input.stockKeepingUnit = '001';
        inputs.add(input);

        IOmnichannelInventoryServiceApi api = (IOmnichannelInventoryServiceApi)Application.ConnectApi.newInstance(IOmnichannelInventoryServiceApi.class);
        
        Test.startTest();
        ConnectApi.OCIReleaseReservationOutputRepresentation output = api.releaseReservation(inputs);
        Test.stopTest();

        System.assert(output.success, 'Release reservation action is failed');
    }

    /**
    * @description Test method of 
    *   OmnichannelInventoryServiceApi.submitInventoryAvailabilityUpload
    */
    @isTest
    static void shouldSubmitInventoryAvailabilityUpload() {
        IOmnichannelInventoryServiceApi api = (IOmnichannelInventoryServiceApi)Application.ConnectApi.newInstance(IOmnichannelInventoryServiceApi.class);

        ConnectApi.BinaryInput input = new ConnectApi.BinaryInput
        (
            Blob.valueOf('blob'), 
            'application/json', 
            'test.json'
        );
        
        Test.startTest();
        ConnectApi.OCIUploadInventoryAvailabilityOutputRepresentation output = api.submitInventoryAvailabilityUpload(input);
        Test.stopTest();

        System.assert(output.success, 'Submit inventory availability upload action is failed');
    }

    /**
    * @description Test method of 
    *   OmnichannelInventoryServiceApi.transferReservation
    */
    @isTest
    static void shouldTransferReservation() {
        ConnectApi.OCITransferReservationSingleInputRepresentation singleReservationInput = new ConnectApi.OCITransferReservationSingleInputRepresentation();
        singleReservationInput.actionRequestId = 'actionRequest_Id';
        singleReservationInput.externalRefId = 'externalRef_Id';
        singleReservationInput.fromLocationGroupIdentifier = 'TEST_LOCATION_GROUP';
        singleReservationInput.ignoreAvailabilityCheck = false;
        singleReservationInput.quantity = 1;
        singleReservationInput.stockKeepingUnit = '001';
        singleReservationInput.toLocationIdentifier = 'TEST_LOCATION';

        ConnectApi.OCITransferReservationInputRepresentation input = new ConnectApi.OCITransferReservationInputRepresentation();
        input.transferRecords = new List<ConnectApi.OCITransferReservationSingleInputRepresentation>{ singleReservationInput };

        IOmnichannelInventoryServiceApi api = (IOmnichannelInventoryServiceApi)Application.ConnectApi.newInstance(IOmnichannelInventoryServiceApi.class);

        Test.startTest();
        ConnectApi.OCITransferReservationOutputRepresentation output = api.transferReservation(input);
        Test.stopTest();

        System.assert(output.success, 'Transfer reservation action is failed');
    }
}