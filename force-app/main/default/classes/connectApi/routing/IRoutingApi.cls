/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 01/08/2021
* @description ReturnOrderApi interface
*/
public interface IRoutingApi {
    /**
    * @description Returns combinations of inventory
    *   locations that can fulfill an order within a
    *   specified limit of shipment splits
    * @param input The input includes the ordered item
    *   quantities, data about available inventory, and,
    *   optionally, a maximum allowable number of shipment
    *   splits
    * @return A list of inventory location combinations that
    *   can fulfill an order without exceeding the maximum 
    *   number of shipments
    */
    ConnectApi.FindRoutesWithFewestSplitsOutputRepresentation findRoutesWithFewestSplits(ConnectApi.FindRoutesWithFewestSplitsInputRepresentation input);

    /**
    * @description Calculates the average distance from sets of
    *   inventory locations to an order recipient, and ranks them.
    *   Use this method to compare the average shipping distances
    *   for different sets of locations that can fulfill an order
    * @param input An order recipient’s geographic location
    *   and information about sets of inventory locations that
    *   can fulfill the order 
    * @return The results of calculating the average distances 
    *   from sets of inventory locations to an order recipient
    */
    ConnectApi.RankAverageDistanceOutputRepresentation rankAverageDistance(ConnectApi.RankAverageDistanceInputRepresentation input);
}