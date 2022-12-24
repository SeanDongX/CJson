package serialization.adaptor

/*
* The factory for json adaptors
*/
public class JsonAdaptorFactory {
    private let map: HashMap<String, JsonAdaptor> = HashMap()
    
    /*
    * Registers the adaptor by identifier
    * @param identifier the identifier
    * @param adaptor the adaptor to register
    */
    public func registrer(identifier: String, adaptor: JsonAdaptor) {
        map.put(identifier, adaptor)
    }   

    /*
    * Gets the json adaptor by identifier
    * @param identifier the identifier
    * @return JsonAdaptor the adaptor for given identifier
    */
    public func getAdaptor(identifier: String): JsonAdaptor {
        return map.get(identifier).getOrThrow({  => AdaptorMissingException("No adaptor registered for ${identifier}") })
    }
}