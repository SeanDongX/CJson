macro package serialization

interface JsonCollectionAdaptor <: JsonAdaptor {
    //func setGenericType(genericType: NodeFormat_Type): Unit
    func setContainerType(containerType: NodeFormat_Type): Unit
}

class ArrayAdaptor <: JsonCollectionAdaptor {
    private var adaptorFactory: JsonAdaptorFactory
    //private var containerType: String = "ArrayList"
    private var containerType: Option<NodeFormat_Type> = None

    public init(adaptorFactory: JsonAdaptorFactory) {
        this.adaptorFactory = adaptorFactory
    }

    protected func getGenericTypeName(): String {
        return getGenericType().asRefType().getIdentifier().value
    }

    private func getGenericType(): NodeFormat_Type {
        return containerType.getOrThrow().asRefType().getArgs()[0]                
    }
    public func setContainerType(containerType: NodeFormat_Type): Unit {
        this.containerType = containerType 
    }

    public func getGenericTypeAdaptor(): JsonAdaptor {
        return this.adaptorFactory.getAdaptor(getGenericTypeName())
    }

    public func fromJsonValue(valueReceiver: Tokens, jsonVar: Tokens): Tokens {
        //TODO: make work with loop eg. Array<Array<Array<<<T>>>
        var adaptor = StringAdaptor()
        var containerTypeIdentifier = containerType.getOrThrow().asRefType().getIdentifier()
        var genericTypeIdentifier = Token(TokenKind.IDENTIFIER, getGenericTypeName())

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