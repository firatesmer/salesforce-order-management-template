
/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 19/07/2021
* @description Route orders to inventory locations
*   in Order Management
*/
public with sharing class OmnichannelInventoryServiceApi extends BaseApi {
    /**
    * @description Create an inventory reservation in 
    *   Omnichannel Inventory
    * @param input Data to reserve inventory at one or
    *   more Omnichannel Inventory locations or location groups
    * @return Result of an Omnichannel Inventory reservation 
    *   creation request
    */
    public ConnectApi.OCICreateReservationOutputRepresentation createReservation(ConnectApi.OCICreateReservationInputRepresentation input) {
        ConnectApi.OCICreateReservationOutputRepresentation output;

        output = !Test.isRunningTest()
            ? ConnectApi.OmnichannelInventoryService.createReservation(input)
            : OmnichannelInventoryDataFactory.getDefaultSuccessOCICreateReservationOutput();

        // super.insertFailedResults(output);
        return output;
    }
    
    /**
    * @description Fulfill one or more inventory reservations
    * @param input A list of inventory reservations to fulfill
    * @return Response to a request to fulfill one or more 
    *   inventory reservations
    */
    public ConnectApi.OCIFulfillReservationOutputRepresentation fulfillReservation(ConnectApi.OCIFulfillReservationInputRepresentation input) {
        ConnectApi.OCIFulfillReservationOutputRepresentation output;

        output = !Test.isRunningTest()
            ? ConnectApi.OmnichannelInventoryService.fulfillReservation(input)
            : OmnichannelInventoryDataFactory.getDefaultSuccessOCIFulfillReservationOutput();

        // super.insertFailedResults(output);
        return output;
    }

    // Subclass of ConnectApi.OCIBaseOutputRepresentation.

    /**
    OCI base var
    + olmayanları koy
    + baseApi için test yaz ve mock data ver error için
     */

    /**
    * @description Retrieve inventory availability data for one
    *   or more products at one or more inventory locations or
    *   location groups
    * @param input Details of a request to retrieve inventory 
    *   availability
    * @return Response to a request for inventory availability data
    */
    public ConnectApi.OCIGetInventoryAvailabilityOutputRepresentation getInventoryAvailability(ConnectApi.OCIGetInventoryAvailabilityInputRepresentation input) {
        ConnectApi.OCIGetInventoryAvailabilityOutputRepresentation output;

        output = !Test.isRunningTest()
            ? ConnectApi.OmnichannelInventoryService.getInventoryAvailability(input)
            : OmnichannelInventoryDataFactory();

        // super.insertFailedResults(output);
        return output;
    }
}