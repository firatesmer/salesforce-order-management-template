/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description ShipmentStatus class
*/
public class ShipmentStatus extends BaseEnum {
    private static final Map<String, ShipmentStatus> STATUSES = new Map<String, ShipmentStatus>();
    
    public static final ShipmentStatus SHIPPED = new ShipmentStatus(Constants.SHIPPED, Constants.SHIPPED);
    public static final ShipmentStatus DELIVERED = new ShipmentStatus(Constants.DELIVERED, Constants.DELIVERED);
         
    private ShipmentStatus(String statusKey, String statusValue) {
        this.enumKey = statusKey;
        this.enumValue = statusValue;

        STATUSES.put(statusKey, this);
    }

    /**
    * @description Returns all statuses
    * @return ShipmentStatus list
    */
    public static ShipmentStatus[] values() {
        return STATUSES.values();
    }
}