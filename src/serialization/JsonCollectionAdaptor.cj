macro package serialization

interface JsonCollectionAdaptor <: JsonAdaptor {
    func setContainerType(containerType: NodeFormat_Type): Unit
}

abstract class JsonCollectionAdaptorImpl <: JsonCollectionAdaptor {
    private var adaptorFactory: JsonAdaptorFactory
    private var containerType: Option<NodeFormat_Type> = None

    public init(adaptorFactory: JsonAdaptorFactory) {
        this.adaptorFactory = adaptorFactory
    }

    func insertValueExpr(valueReceiver_Tk: Tokens, genericVar_Tk: Tokens): Tokens

    public func setContainerType(containerType: NodeFormat_Type): Unit {
        this.containerType = containerType 
    }

    protected func getContainerIdentifier(): String {
        return this.containerType.getOrThrow().getTypeName()
    }

    protected func getGenericType(): NodeFormat_Type {
        return containerType.getOrThrow().asRefType().getArgs()[0]                
    }
    
    protected func getGenericTypeName(): String {
        return getGenericType().getTypeName()
    }

    public func getGenericTypeAdaptor(): JsonAdaptor {
        return this.adaptorFactory.getAdaptor(getGenericTypeName())
    }

    public func fromJsonValue(valueReceiver_Tk: Tokens, jsonVar_Tk: Tokens, varIdentifierName: String): Tokens {
        var genericTypeName =  getGenericTypeName()
        var genericAdaptor = adaptorFactory.getAdaptor(genericTypeName)
        
        if (genericAdaptor is JsonCollectionAdaptor) {
             //TODO: make work with loop eg. Array<Array<Array<<<T>>>
             throw Exception("Collection inside collection (such as Array<Array<T>>) is not supported ")
        }
        
        var containType_Tk = containerType.getOrThrow().asRefType().getIdentifier()
        var genericType_Tk = Token(TokenKind.IDENTIFIER, genericTypeName)
        var genericVar_Tk = Tokens([Token(TokenKind.IDENTIFIER, varIdentifierName + "_elementValue")])
        var itemVar_Tk = Tokens([Token(TokenKind.IDENTIFIER, "item")])

        var genericValueProcess_Tk = genericAdaptor.fromJsonValue(genericVar_Tk, itemVar_Tk, "")
        var insertValueExpr_Tk = insertValueExpr(valueReceiver_Tk, genericVar_Tk)
        return quote(
            $valueReceiver_Tk = $containType_Tk<$genericType_Tk>()
            var $genericVar_Tk: $genericType_Tk

            for ($itemVar_Tk in $jsonVar_Tk.asArray().getOrThrow().getItems()) {                
                $genericValueProcess_Tk
                $insertValueExpr_Tk
            }
        )
    }

     public func toJsonValueFunc(valueSource_Tk: Tokens, funcName_Tk: Tokens): Tokens {
        var genericTypeName =  getGenericTypeName()
        var genericAdaptor = adaptorFactory.getAdaptor(genericTypeName)
                        
        if (genericAdaptor is JsonCollectionAdaptor) {
             //TODO: make work with loop eg. Array<Array<Array<<<T>>>
             throw Exception("Collection inside collection (such as Array<Array<T>>) is not supported ")
        }

        var elementVat_Tk = quote(element)
        var containerIdentifier = getContainerIdentifier()
        var genericValueFuncName_TK = Tokens([Token(TokenKind.IDENTIFIER, "getValue_" + containerIdentifier)])
        var geneticValueFunc_Tk = genericAdaptor.toJsonValueFunc(elementVat_Tk, genericValueFuncName_TK)

        return quote(
            func $funcName_Tk() {
                var jsonArray = JsonArray()            
                for ($elementVat_Tk in $valueSource_Tk) {
                    //define a getValue func in place
                    $geneticValueFunc_Tk

                    //invoke the func
                    jsonArray.add($genericValueFuncName_TK())
                }

                return jsonArray
            }
        )
    }
}

class ArrayListAdaptor <: JsonCollectionAdaptorImpl {
    public init(adaptorFactory: JsonAdaptorFactory) {
        super(adaptorFactory)
    }

    protected func insertValueExpr(valueReceiver_Tk: Tokens, genericVar_Tk: Tokens): Tokens {
        return quote(
            $valueReceiver_Tk.add($genericVar_Tk)
        )
    }
}

class HashSetAdaptor <: JsonCollectionAdaptorImpl {
    public init(adaptorFactory: JsonAdaptorFactory) {
        super(adaptorFactory)
    }
    
    protected func insertValueExpr(valueReceiver_Tk: Tokens, genericVar_Tk: Tokens): Tokens {
        return quote(
            $valueReceiver_Tk.put($genericVar_Tk)
        )
    }
}


