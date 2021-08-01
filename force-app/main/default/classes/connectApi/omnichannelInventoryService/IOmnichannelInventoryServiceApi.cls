/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 01/08/2021
* @description OmnichannelInventoryServiceApi interface
*/
public interface IOmnichannelInventoryServiceApi {
    /**
    * @description Create an inventory reservation in 
    *   Omnichannel Inventory
    * @param input Data to reserve inventory at one or
    *   more Omnichannel Inventory locations or location groups
    * @return Result of an Omnichannel Inventory reservation 
    *   creation request
    */
    ConnectApi.OCICreateReservationOutputRepresentation createReservation(ConnectApi.OCICreateReservationInputRepresentation input);

    /**
    * @description Fulfill one or more inventory reservations
    * @param input A list of inventory reservations to fulfill
    * @return Response to a request to fulfill one or more 
    *   inventory reservations
    */
    ConnectApi.OCIFulfillReservationOutputRepresentation fulfillReservation(ConnectApi.OCIFulfillReservationInputRepresentation input);

    /**
    * @description Retrieve inventory availability data for one
    *   or more products at one or more inventory locations or
    *   location groups
    * @param input Details of a request to retrieve inventory 
    *   availability
    * @return Response to a request for inventory availability data
    */
    ConnectApi.OCIGetInventoryAvailabilityOutputRepresentation getInventoryAvailability(ConnectApi.OCIGetInventoryAvailabilityInputRepresentation input);

    /**
    * @description Retrieve the status of an inventory availability
    *   upload job
    * @param uploadId The upload Id of the upload job
    * @return Detailed status of an upload inventory availability job
    */
    ConnectApi.OCIUploadInventoryAvailabilityStatusOutputRepresentation getInventoryAvailabilityUploadStatus(String uploadId);

    /**
    * @description Retrieve the status of a publish location
    *   structure job
    * @param uploadId The upload Id of the publish job
    * @return Detailed status of a publish location structure job
    */
    ConnectApi.OCIPublishLocationStructureStatusOutputRepresentation getPublishLocationStructureStatus(String uploadId);

    /**
    * @description Asynchronously publish information about 
    *   your inventory locations and location groups to 
    *   Omnichannel Inventory. The publish includes records
    *   whose IsEnabled and ShouldSyncWithOci fields are both
    *   true. This method returns an ID that you can use to 
    *   retrieve the status of the publish job
    * @return Detailed status of a publish location structure job
    */
    ConnectApi.OCIPublishLocationStructureOutputRepresentation publishLocationStructure();

    /**
    * @description Release one or more existing inventory 
    *   reservations to free up that inventory
    * @param inputs A list of inventory reservation to release
    * @return Response to a request to release one or more inventory reservations
    */
    ConnectApi.OCIReleaseReservationOutputRepresentation releaseReservation(List<ConnectApi.OCIReleaseReservationSingleInputRepresentation> inputs);

    /**
    * @description Upload an inventory availability data file to
    *   Omnichannel Inventory
    * @param input JSON file containing inventory availability data
    *   blob - {blob} - Contents of the file to be used for input
    *   contentType - {string} - MIME type description of the content
    *   blob - {string} - filename - File name with the file extension
    * @return Response to an upload inventory availability job
    */
    ConnectApi.OCIUploadInventoryAvailabilityOutputRepresentation submitInventoryAvailabilityUpload(ConnectApi.BinaryInput input);

    /**
    * @description Transfer one or more inventory reservations between
    *   locations or location groups. This API doesn’t change physical
    *   quantities, but reduces the reserved quantity at the source and
    *   increases it at the destination
    * @param input A list of inventory reservation transfers and specifies
    *   whether a single failure cancels the entire list
    * @return Response to a request to transfer one or more inventory reservations
    */
    ConnectApi.OCITransferReservationOutputRepresentation transferReservation(ConnectApi.OCITransferReservationInputRepresentation input);
}