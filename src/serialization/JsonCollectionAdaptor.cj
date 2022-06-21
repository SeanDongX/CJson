macro package serialization

interface JsonCollectionAdaptor <: JsonAdaptor {
    func setGenericType(typeName: String): Unit
    func setContainerType(typeName: String): Unit
}

class ArrayAdaptor <: JsonCollectionAdaptor {
    private var adaptorFactory: JsonAdaptorFactory
    private var containerType: String = "ArrayList"
    private var genericType: String = "String"

    public init(adaptorFactory: JsonAdaptorFactory) {
        this.adaptorFactory = adaptorFactory
    }

    public func setContainerType(typeName: String) {
        containerType = typeName
    }

    public func setGenericType(typeName: String) {
        genericType = typeName
    }

    public func getGenericTypeAdaptor(): JsonAdaptor {
        this.adaptorFactory.getAdaptor(this.genericType)
    }

    public func fromJsonValue(valueReceiver: Tokens, jsonVar: Tokens): Tokens {
        var adaptor = StringAdaptor()
        var containerTypeIdentifier = Token(TokenKind.IDENTIFIER, containerType)
        var genericTypeIdentifier = Token(TokenKind.IDENTIFIER, genericType)
        
        return quote(
            $valueReceiver = $containerTypeIdentifier<$genericTypeIdentifier>()
            for (jsonValue in $jsonVar.asArray().getOrThrow().getItems()) {
                ////TODO: User adaptor to evaluate: 
                ret.array.add(jsonValue.asString().getOrThrow().getValue())
                //ret.array.add($(adaptor.fromJsonValue($jsonValue))
            }
        ) 
    }

    public func toJsonValue(mapToken: Tokens,  keyToken: Tokens, identifier: Tokens): Tokens {
        return quote(
            var jsonArray = JsonArray()            
            for (element in $identifier) {
                ////TODO: User adaptor to evaluate: $(adaptor.toJsonValue(jsonValue)
                jsonArray.add(JsonString(element))
            }

            $mapToken.put($keyToken, jsonArray)
        )
    }
}