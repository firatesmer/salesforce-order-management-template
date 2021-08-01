
/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 19/07/2021
* @description Route orders to inventory locations
*   in Order Management
*/
public virtual without sharing class OmnichannelInventoryServiceApi extends ConnectApiOmnichannelInventoryBase implements IOmnichannelInventoryServiceApi {
    /**
    * @description Create an inventory reservation in 
    *   Omnichannel Inventory
    * @param input Data to reserve inventory at one or
    *   more Omnichannel Inventory locations or location groups
    * @return Result of an Omnichannel Inventory reservation 
    *   creation request
    */
    public virtual ConnectApi.OCICreateReservationOutputRepresentation createReservation(ConnectApi.OCICreateReservationInputRepresentation input) {
        ConnectApi.OCICreateReservationOutputRepresentation output;

        output = !Test.isRunningTest()
            ? ConnectApi.OmnichannelInventoryService.createReservation(input)
            : OmnichannelInventoryTestDataFactory.getSuccessCreateReservationOutput();

        super.insertFailedResults(output);
        return output;
    }
    
    /**
    * @description Fulfill one or more inventory reservations
    * @param input A list of inventory reservations to fulfill
    * @return Response to a request to fulfill one or more 
    *   inventory reservations
    */
    public virtual ConnectApi.OCIFulfillReservationOutputRepresentation fulfillReservation(ConnectApi.OCIFulfillReservationInputRepresentation input) {
        ConnectApi.OCIFulfillReservationOutputRepresentation output;

        output = !Test.isRunningTest()
            ? ConnectApi.OmnichannelInventoryService.fulfillReservation(input)
            : OmnichannelInventoryTestDataFactory.getSuccessFulfillReservationOutput();

        super.insertFailedResults(output);
        return output;
    }

    /**
    * @description Retrieve inventory availability data for one
    *   or more products at one or more inventory locations or
    *   location groups
    * @param input Details of a request to retrieve inventory 
    *   availability
    * @return Response to a request for inventory availability data
    */
    public virtual ConnectApi.OCIGetInventoryAvailabilityOutputRepresentation getInventoryAvailability(ConnectApi.OCIGetInventoryAvailabilityInputRepresentation input) {
        ConnectApi.OCIGetInventoryAvailabilityOutputRepresentation output;

        output = !Test.isRunningTest()
            ? ConnectApi.OmnichannelInventoryService.getInventoryAvailability(input)
            : OmnichannelInventoryTestDataFactory.getSuccessGetInventoryAvailabilityOutput();

        super.insertFailedResults(output);
        return output;
    }

    /**
    * @description Retrieve the status of an inventory availability
    *   upload job
    * @param uploadId The upload Id of the upload job
    * @return Detailed status of an upload inventory availability job
    */
    public virtual ConnectApi.OCIUploadInventoryAvailabilityStatusOutputRepresentation getInventoryAvailabilityUploadStatus(String uploadId) {
        ConnectApi.OCIUploadInventoryAvailabilityStatusOutputRepresentation output;

        output = !Test.isRunningTest()
            ? ConnectApi.OmnichannelInventoryService.getInventoryAvailabilityUploadStatus(uploadId)
            : OmnichannelInventoryTestDataFactory.getSuccessGetInventoryAvailabilityUploadStatusOutput();

        super.insertFailedResults(output);
        return output;
    }

    /**
    * @description Retrieve the status of a publish location
    *   structure job
    * @param uploadId The upload Id of the publish job
    * @return Detailed status of a publish location structure job
    */
    public virtual ConnectApi.OCIPublishLocationStructureStatusOutputRepresentation getPublishLocationStructureStatus(String uploadId) {
        ConnectApi.OCIPublishLocationStructureStatusOutputRepresentation output;

        output = !Test.isRunningTest()
            ? ConnectApi.OmnichannelInventoryService.getPublishLocationStructureStatus(uploadId)
            : OmnichannelInventoryTestDataFactory.getSuccessGetPublishLocationStructureStatusOutput();

        super.insertFailedResults(output);
        return output;
    }

    /**
    * @description Asynchronously publish information about 
    *   your inventory locations and location groups to 
    *   Omnichannel Inventory. The publish includes records
    *   whose IsEnabled and ShouldSyncWithOci fields are both
    *   true. This method returns an ID that you can use to 
    *   retrieve the status of the publish job
    * @return Detailed status of a publish location structure job
    */
    public virtual ConnectApi.OCIPublishLocationStructureOutputRepresentation publishLocationStructure() {
        ConnectApi.OCIPublishLocationStructureOutputRepresentation output;

        output = !Test.isRunningTest()
            ? ConnectApi.OmnichannelInventoryService.publishLocationStructure()
            : OmnichannelInventoryTestDataFactory.getSuccessPublishLocationStructureOutput();

        super.insertFailedResults(output);
        return output;
    }

    /**
    * @description Release one or more existing inventory 
    *   reservations to free up that inventory
    * @param inputs A list of inventory reservation to release
    * @return Response to a request to release one or more inventory reservations
    */
    public virtual ConnectApi.OCIReleaseReservationOutputRepresentation releaseReservation(List<ConnectApi.OCIReleaseReservationSingleInputRepresentation> inputs) {
        ConnectApi.OCIReleaseReservationOutputRepresentation output;

        ConnectApi.OCIReleaseReservationInputRepresentation input = new ConnectApi.OCIReleaseReservationInputRepresentation();
        input.releaseRecords = inputs;

        output = !Test.isRunningTest()
            ? ConnectApi.OmnichannelInventoryService.releaseReservation(input)
            : OmnichannelInventoryTestDataFactory.getSuccessReleaseReservationOutput();

        super.insertFailedResults(output);
        return output;
    }

    /**
    * @description Upload an inventory availability data file to
    *   Omnichannel Inventory
    * @param input JSON file containing inventory availability data
    *   blob - {blob} - Contents of the file to be used for input
    *   contentType - {string} - MIME type description of the content
    *   blob - {string} - filename - File name with the file extension
    * @return Response to an upload inventory availability job
    */
    public virtual ConnectApi.OCIUploadInventoryAvailabilityOutputRepresentation submitInventoryAvailabilityUpload(ConnectApi.BinaryInput input) {
        ConnectApi.OCIUploadInventoryAvailabilityOutputRepresentation output;

        output = !Test.isRunningTest()
            ? ConnectApi.OmnichannelInventoryService.submitInventoryAvailabilityUpload(input)
            : OmnichannelInventoryTestDataFactory.getSuccessSubmitInventoryAvailabilityUploadOutput();

        super.insertFailedResults(output);
        return output;
    }

    /**
    * @description Transfer one or more inventory reservations between
    *   locations or location groups. This API doesn’t change physical
    *   quantities, but reduces the reserved quantity at the source and
    *   increases it at the destination
    * @param input A list of inventory reservation transfers and specifies
    *   whether a single failure cancels the entire list
    * @return Response to a request to transfer one or more inventory reservations
    */
    public virtual ConnectApi.OCITransferReservationOutputRepresentation transferReservation(ConnectApi.OCITransferReservationInputRepresentation input) {
        ConnectApi.OCITransferReservationOutputRepresentation output;

        output = !Test.isRunningTest()
            ? ConnectApi.OmnichannelInventoryService.transferReservation(input)
            : OmnichannelInventoryTestDataFactory.getSuccessTransferReservationOutput();

        super.insertFailedResults(output);
        return output;
    }
}