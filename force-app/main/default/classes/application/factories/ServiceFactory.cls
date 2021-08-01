/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 31/07/2021
* @description Factory class for services
*/
public virtual class ServiceFactory {
    protected Map<Type, Type> serviceInterfaceTypeToServiceTypeMap;

    /**
    * @description Constructor
    * @param serviceInterfaceTypeToServiceTypeMap Map of interface type to service type
    */
    public ServiceFactory(Map<Type, Type> serviceInterfaceTypeToServiceTypeMap) {
        this.serviceInterfaceTypeToServiceTypeMap = serviceInterfaceTypeToServiceTypeMap;
    }

    /**
    * @description Creates a new instance of selector by the type
    * @param serviceInterfaceType Type of the service interface
    * @return Service instance
    */
    public virtual Object newInstance(Type serviceInterfaceType) {
        // get the type of the service from the map passed into constructor
        Type serviceType = serviceInterfaceTypeToServiceTypeMap.get(serviceInterfaceType);

        if (serviceType == null) {
            throw new ApplicationException('No implementation registered for the service interface ' + serviceInterfaceType.getName());
        }

        return serviceType.newInstance();
    }
}