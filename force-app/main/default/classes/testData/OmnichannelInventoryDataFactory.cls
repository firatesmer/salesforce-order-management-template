/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description Test data factory for Omnichannel Inventory Service class
*/
@isTest
public with sharing class OmnichannelInventoryDataFactory {
    private final static String TIME_FORMAT = 'YYYY-MM-dd\'T\'HH:mm:ss\'Z\'';

    /**
    * @description Creates OCICreateReservationOutput test data
    * @return Default create reservation output
    */
    public static ConnectApi.OCICreateReservationOutputRepresentation getDefaultSuccessOCICreateReservationOutput() {
        ConnectApi.OCICreateReservationSingleOutputRepresentation outputItem = new ConnectApi.OCICreateReservationSingleOutputRepresentation();
        outputItem.locationGroupIdentifier = 'TEST_LOCATION_GROUP';
        outputItem.quantity = 1;
        outputItem.stockKeepingUnit = '001';

        ConnectApi.OCICreateReservationOutputRepresentation output = new ConnectApi.OCICreateReservationOutputRepresentation();
        output.details = new List<ConnectApi.OCICreateReservationSingleOutputRepresentation>{ outputItem };
        output.expirationTime = DateTime.now().addDays(1).format(TIME_FORMAT);
        output.reservationTime = DateTime.now().format(TIME_FORMAT);
        output.success = true;

        return output;
    }

    /**
    * @description Creates OCIFulfillReservationOutput test data
    * @return Default fulfill reservation output
    */
    public static ConnectApi.OCIFulfillReservationOutputRepresentation getDefaultSuccessOCIFulfillReservationOutput() {
        ConnectApi.OCIFulfillReservationOutputRepresentation output = new ConnectApi.OCIFulfillReservationOutputRepresentation();
        output.success = true;

        return output;
    }
}