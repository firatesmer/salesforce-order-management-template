/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description Test data factory for Omnichannel Inventory Service class
*/
@isTest
public with sharing class OmnichannelInventoryDataFactory {
    private final static String TIME_FORMAT = 'YYYY-MM-dd\'T\'HH:mm:ss\'Z\'';
    private final static String TEST_LOCATION_GROUP = 'TEST_LOCATION_GROUP';

    /**
    * @description Creates OCICreateReservationOutput test data
    * @return Default success create reservation output
    */
    public static ConnectApi.OCICreateReservationOutputRepresentation getDefaultSuccessCreateReservationOutput() {
        ConnectApi.OCICreateReservationSingleOutputRepresentation outputItem = new ConnectApi.OCICreateReservationSingleOutputRepresentation();
        outputItem.locationGroupIdentifier = TEST_LOCATION_GROUP;
        outputItem.quantity = 1;
        outputItem.stockKeepingUnit = '001';

        ConnectApi.OCICreateReservationOutputRepresentation output = new ConnectApi.OCICreateReservationOutputRepresentation();
        output.details = new List<ConnectApi.OCICreateReservationSingleOutputRepresentation>{ outputItem };
        output.expirationTime = DateTime.now().addDays(1).format(TIME_FORMAT);
        output.reservationTime = DateTime.now().format(TIME_FORMAT);
        output.success = true;
        output.errors = new List<ConnectApi.OCICreateReservationErrorOutputRepresentation>();

        return output;
    }

    /**
    * @description Creates OCIFulfillReservationOutput test data
    * @return Default success fulfill reservation output
    */
    public static ConnectApi.OCIFulfillReservationOutputRepresentation getDefaultSuccessFulfillReservationOutput() {
        ConnectApi.OCIFulfillReservationOutputRepresentation output = new ConnectApi.OCIFulfillReservationOutputRepresentation();
        output.success = true;
        output.errors = new List<ConnectApi.OCIFulfillReservationErrorOutputRepresentation>();

        return output;
    }

    /**
    * @description Creates OCIGetInventoryAvailabilityOutputRepresentation test data
    * @return Default success get inventory availability output
    */
    public static ConnectApi.OCIGetInventoryAvailabilityOutputRepresentation getDefaultSuccessGetInventoryAvailabilityOutput() {
        ConnectApi.OCIInventoryRecordOutputRepresentation inventoryRecord = new ConnectApi.OCIInventoryRecordOutputRepresentation();
        inventoryRecord.availableToFulfill = 1;
        inventoryRecord.availableToOrder = 1;
        inventoryRecord.effectiveDate = DateTime.now();
        inventoryRecord.onHand = 1;
        inventoryRecord.reserved = 0;
        inventoryRecord.safetyStockCount = 0;
        inventoryRecord.stockKeepingUnit = '001';

        ConnectApi.OCILocationGroupAvailabilityOutputRepresentation locationGroupItem = new ConnectApi.OCILocationGroupAvailabilityOutputRepresentation();
        locationGroupItem.inventoryRecords = new List<ConnectApi.OCIInventoryRecordOutputRepresentation>{ inventoryRecord };
        locationGroupItem.locationGroupIdentifier = TEST_LOCATION_GROUP;

        ConnectApi.OCIGetInventoryAvailabilityOutputRepresentation output = new ConnectApi.OCIGetInventoryAvailabilityOutputRepresentation();
        output.locationGroups = new List<ConnectApi.OCILocationGroupAvailabilityOutputRepresentation>{ locationGroupItem };
        output.success = true;
        output.errors = new List<ConnectApi.ErrorResponse>();

        return output;
    }

    /**
    * @description Creates OCIGetInventoryAvailabilityOutputRepresentation test data
    * @return Default success get inventory availability upload status output
    */
    public static ConnectApi.OCIUploadInventoryAvailabilityStatusOutputRepresentation getDefaultSuccessGetInventoryAvailabilityUploadStatusOutput() {
        ConnectApi.OCIUploadInventoryAvailabilityStatusOutputRepresentation output = new ConnectApi.OCIUploadInventoryAvailabilityStatusOutputRepresentation();
        output.endTimeUTC = DateTime.now().format(TIME_FORMAT);
        output.recordsProcessedCount = 100;
        output.recordsReadCount = 100;
        output.recordsSkippedCount = 0;
        output.startTimeUTC = DateTime.now().addMinutes(-10).format(TIME_FORMAT);
        output.status = 'COMPLETED';
        output.uploadId = 'some_id';
        output.validationErrors = new List<String>();
        output.validationStatus = '';
        output.success = true;
        output.errors = new List<ConnectApi.ErrorResponse>();

        return output;
    }

    /**
    * @description Creates OCIPublishLocationStructureStatusOutputRepresentation test data
    * @return Default success get publish location structure status output
    */
    public static ConnectApi.OCIPublishLocationStructureStatusOutputRepresentation getDefaultSuccessGetPublishLocationStructureStatusOutput() {
        ConnectApi.OCIPublishLocationStructureStatusOutputRepresentation output = new ConnectApi.OCIPublishLocationStructureStatusOutputRepresentation();
        output.endTimeUTC = DateTime.now().format(TIME_FORMAT);
        output.recordsProcessedCount = 100;
        output.recordsReadCount = 100;
        output.recordsSkippedCount = 0;
        output.startTimeUTC = DateTime.now().addMinutes(-10).format(TIME_FORMAT);
        output.status = 'COMPLETED';
        output.uploadId = 'some_id';
        output.validationErrors = new List<String>();
        output.validationStatus = '';
        output.success = true;
        output.errors = new List<ConnectApi.ErrorResponse>();

        return output;
    }

    /**
    * @description Creates OCIPublishLocationStructureOutputRepresentation test data
    * @return Default success publish location structure output
    */
    public static ConnectApi.OCIPublishLocationStructureOutputRepresentation getDefaultSuccessPublishLocationStructureOutput() {
        ConnectApi.OCIPublishLocationStructureOutputRepresentation output = new ConnectApi.OCIPublishLocationStructureOutputRepresentation();
        output.uploadId = 'upload_id';
        output.success = true;
        output.errors = new List<ConnectApi.ErrorResponse>();

        return output;
    }

    /**
    * @description Creates OCIReleaseReservationOutputRepresentation test data
    * @return Default success release reservation output
    */
    public static ConnectApi.OCIReleaseReservationOutputRepresentation getDefaultSuccessReleaseReservationOutput() {
        ConnectApi.OCIReleaseReservationOutputRepresentation output = new ConnectApi.OCIReleaseReservationOutputRepresentation();
        output.success = true;
        output.errors = new List<ConnectApi.OCIReleaseReservationErrorOutputRepresentation>();

        return output;
    }

    /**
    * @description Creates OCIUploadInventoryAvailabilityOutputRepresentation test data
    * @return Default success submit inventory availability upload output
    */
    public static ConnectApi.OCIUploadInventoryAvailabilityOutputRepresentation getDefaultSuccessSubmitInventoryAvailabilityUploadOutput() {
        ConnectApi.OCIUploadInventoryAvailabilityOutputRepresentation output = new ConnectApi.OCIUploadInventoryAvailabilityOutputRepresentation();
        output.uploadId = 'upload_id';
        output.success = true;
        output.errors = new List<ConnectApi.ErrorResponse>();

        return output;
    }
}