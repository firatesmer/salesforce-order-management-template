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
    * @return Success create reservation output
    */
    public static ConnectApi.OCICreateReservationOutputRepresentation getSuccessCreateReservationOutput() {
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
    * @description Creates OCICreateReservationOutputRepresentation test data for fail
    * @return Fail get inventory availability output
    */
    public static ConnectApi.OCICreateReservationOutputRepresentation getFailCreateReservationOutput() {
        ConnectApi.OCICreateReservationErrorOutputRepresentation error = new ConnectApi.OCICreateReservationErrorOutputRepresentation();
        error.message = 'UNKOWN_EXCEPTION';
        error.errorCode = '001';
        
        ConnectApi.OCICreateReservationOutputRepresentation output = new ConnectApi.OCICreateReservationOutputRepresentation();
        output.success = false;
        output.errors = new List<ConnectApi.OCICreateReservationErrorOutputRepresentation>{ error };

        return output;
    }

    /**
    * @description Creates OCIFulfillReservationOutput test data
    * @return Success fulfill reservation output
    */
    public static ConnectApi.OCIFulfillReservationOutputRepresentation getSuccessFulfillReservationOutput() {
        ConnectApi.OCIFulfillReservationOutputRepresentation output = new ConnectApi.OCIFulfillReservationOutputRepresentation();
        output.success = true;
        output.errors = new List<ConnectApi.OCIFulfillReservationErrorOutputRepresentation>();

        return output;
    }

    /**
    * @description Creates OCIFulfillReservationOutput test data for fail
    * @return Success fulfill reservation output
    */
    public static ConnectApi.OCIFulfillReservationOutputRepresentation getFailFulfillReservationOutput() {
        ConnectApi.OCIFulfillReservationErrorOutputRepresentation error = new ConnectApi.OCIFulfillReservationErrorOutputRepresentation();
        error.message = 'UNKOWN_EXCEPTION';
        error.errorCode = '001';
        
        ConnectApi.OCIFulfillReservationOutputRepresentation output = new ConnectApi.OCIFulfillReservationOutputRepresentation();
        output.success = false;
        output.errors = new List<ConnectApi.OCIFulfillReservationErrorOutputRepresentation>{ error };

        return output;
    }

    /**
    * @description Creates OCIGetInventoryAvailabilityOutputRepresentation test data
    * @return Success get inventory availability output
    */
    public static ConnectApi.OCIGetInventoryAvailabilityOutputRepresentation getSuccessGetInventoryAvailabilityOutput() {
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
    * @description Creates OCIGetInventoryAvailabilityOutputRepresentation test data for fail
    * @return Fail get inventory availability output
    */
    public static ConnectApi.OCIGetInventoryAvailabilityOutputRepresentation getFailInventoryAvailabilityOutputRepresentation() {
        ConnectApi.ErrorResponse error = new ConnectApi.ErrorResponse();
        error.message = 'UNKOWN_EXCEPTION';
        error.errorCode = '001';

        ConnectApi.OCIGetInventoryAvailabilityOutputRepresentation output = new ConnectApi.OCIGetInventoryAvailabilityOutputRepresentation();
        output.success = false;
        output.errors = new List<ConnectApi.ErrorResponse>{ error };

        return output;
    }

    /**
    * @description Creates OCIUploadInventoryAvailabilityStatusOutputRepresentation test data
    * @return Success get inventory availability upload status output
    */
    public static ConnectApi.OCIUploadInventoryAvailabilityStatusOutputRepresentation getSuccessGetInventoryAvailabilityUploadStatusOutput() {
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
    * @return Success get publish location structure status output
    */
    public static ConnectApi.OCIPublishLocationStructureStatusOutputRepresentation getSuccessGetPublishLocationStructureStatusOutput() {
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
    * @return Success publish location structure output
    */
    public static ConnectApi.OCIPublishLocationStructureOutputRepresentation getSuccessPublishLocationStructureOutput() {
        ConnectApi.OCIPublishLocationStructureOutputRepresentation output = new ConnectApi.OCIPublishLocationStructureOutputRepresentation();
        output.uploadId = 'upload_id';
        output.success = true;
        output.errors = new List<ConnectApi.ErrorResponse>();

        return output;
    }

    /**
    * @description Creates OCIReleaseReservationOutputRepresentation test data
    * @return Success release reservation output
    */
    public static ConnectApi.OCIReleaseReservationOutputRepresentation getSuccessReleaseReservationOutput() {
        ConnectApi.OCIReleaseReservationOutputRepresentation output = new ConnectApi.OCIReleaseReservationOutputRepresentation();
        output.success = true;
        output.errors = new List<ConnectApi.OCIReleaseReservationErrorOutputRepresentation>();

        return output;
    }

    /**
    * @description Creates OCIReleaseReservationOutputRepresentation test data for fail
    * @return Fail release reservation output
    */
    public static ConnectApi.OCIReleaseReservationOutputRepresentation getFailReleaseReservationOutput() {
        ConnectApi.OCIReleaseReservationErrorOutputRepresentation error = new ConnectApi.OCIReleaseReservationErrorOutputRepresentation();
        error.message = 'UNKOWN_EXCEPTION';
        error.errorCode = '001';

        ConnectApi.OCIReleaseReservationOutputRepresentation output = new ConnectApi.OCIReleaseReservationOutputRepresentation();
        output.success = false;
        output.errors = new List<ConnectApi.OCIReleaseReservationErrorOutputRepresentation>{ error };

        return output;
    }

    /**
    * @description Creates OCIUploadInventoryAvailabilityOutputRepresentation test data
    * @return Success submit inventory availability upload output
    */
    public static ConnectApi.OCIUploadInventoryAvailabilityOutputRepresentation getSuccessSubmitInventoryAvailabilityUploadOutput() {
        ConnectApi.OCIUploadInventoryAvailabilityOutputRepresentation output = new ConnectApi.OCIUploadInventoryAvailabilityOutputRepresentation();
        output.uploadId = 'upload_id';
        output.success = true;
        output.errors = new List<ConnectApi.ErrorResponse>();

        return output;
    }

    /**
    * @description Creates OCITransferReservationOutputRepresentation test data
    * @return Success transfer reservation output
    */
    public static ConnectApi.OCITransferReservationOutputRepresentation getSuccessTransferReservationOutput() {
        ConnectApi.OCITransferReservationOutputRepresentation output = new ConnectApi.OCITransferReservationOutputRepresentation();
        output.success = true;
        output.errors = new List<ConnectApi.OCITransferReservationErrorOutputRepresentation>();

        return output;
    }

    /**
    * @description Creates OCITransferReservationOutputRepresentation test data for fail
    * @return Success transfer reservation output
    */
    public static ConnectApi.OCITransferReservationOutputRepresentation getFailTransferReservationOutput() {
        ConnectApi.OCITransferReservationErrorOutputRepresentation error = new ConnectApi.OCITransferReservationErrorOutputRepresentation();
        error.message = 'UNKOWN_EXCEPTION';
        error.errorCode = '001';

        ConnectApi.OCITransferReservationOutputRepresentation output = new ConnectApi.OCITransferReservationOutputRepresentation();
        output.success = false;
        output.errors = new List<ConnectApi.OCITransferReservationErrorOutputRepresentation>{ error };

        return output;
    }
}