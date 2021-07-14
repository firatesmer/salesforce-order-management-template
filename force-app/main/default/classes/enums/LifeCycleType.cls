/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 14/07/2021
* @description LifeCycleType class
*/
public class LifeCycleType extends BaseEnum {
    private static final Map<String, LifeCycleType> STATUSES = new Map<String, LifeCycleType>();
    
    public static final LifeCycleType MANAGED = new LifeCycleType(Constants.MANAGED, Constants.MANAGED);
    public static final LifeCycleType UNMANAGED = new LifeCycleType(Constants.UNMANAGED, Constants.UNMANAGED);
         
    private LifeCycleType(String statusKey, String statusValue) {
        this.enumKey = statusKey;
        this.enumValue = statusValue;

        STATUSES.put(statusKey, this);
    }

    /**
    * @description Returns all statuses
    * @return LifeCycleType list
    */
    public static LifeCycleType[] values() {
        return STATUSES.values();
    }
}
