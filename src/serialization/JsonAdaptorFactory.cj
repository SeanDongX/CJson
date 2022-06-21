macro package serialization

class JsonAdaptorFactory {
    private let map: HashMap<String, JsonAdaptor> = HashMap()
    // private let collectionMap: HashMap<String, CollectionJsonAdaptor> = HashMap()
    
    public func registrer(identifier: String, adaptor: JsonAdaptor) {
        map.put(identifier, adaptor)
    }
    
    // public func registrer(identifierValue: String, adaptor: CollectionJsonAdaptor) {
    //     collectionMap.put(identifierValue, adaptor)
    // }

    public func getAdaptor(identifier: String): JsonAdaptor {
        return map.get(identifier).getOrThrow({ AdaptorMissingException("No adaptor registered for ${identifier}") })
    }

    // public func getCollectionAdaptor(identifier: String): CollectionJsonAdaptor {
    //     return collectionMap.get(identifier).getOrThrow({ AdaptorMissingException("No collection adaptor registered for ${identifier}") })
    // }
}