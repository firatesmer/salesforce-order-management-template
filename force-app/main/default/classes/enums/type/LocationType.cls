/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description Location type class
*/
public class LocationType extends BaseEnum {
    private static final Map<String, LocationType> TYPES = new Map<String, LocationType>();
    
    public static final LocationType WAREHOUSE = new LocationType(Constants.WAREHOUSE, Constants.WAREHOUSE);
    public static final LocationType STORE = new LocationType(Constants.STORE, Constants.STORE);
    public static final LocationType VIRTUAL_C = new LocationType(Constants.VIRTUAL_C, Constants.VIRTUAL_C);
         
    private LocationType(String typeKey, String typeValue) {
        this.enumKey = typeKey;
        this.enumValue = typeValue;

        TYPES.put(typeKey, this);
    }

    /**
    * @description Returns all types
    * @return Location type list
    */
    public static LocationType[] values() {
        return TYPES.values();
    }
}