macro package serialization

class JsonAdaptorFactory {
    private let map: HashMap<String, JsonAdaptor> = HashMap()
    
    public func registrer(identifierValue: String, adaptor: JsonAdaptor) {
        map.put(identifierValue, adaptor)
    }

    public func getAdaptor(identifier: String): JsonAdaptor {
        return map.get(identifier).getOrThrow({ AdaptorMissingException("No adaptor registered for ${identifier}") })
    }
}