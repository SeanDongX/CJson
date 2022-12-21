package serialization

/*
* Core implementation of JsonAdaptor for collections
*/
abstract class JsonCollectionAdaptorImpl <: Adaptor & JsonAdaptor {
    private var adaptorFactory: JsonAdaptorFactory
    
    public init(defalutValueExprStore: DefaultValueExprStore, adaptorFactory: JsonAdaptorFactory) {
        super(defalutValueExprStore)
        this.adaptorFactory = adaptorFactory
    }

    /*
    * Abstract func for inserting generic var into collections
    * @param valueReceiver_Tk the collection var token to receive the generic value
    * @param genericVar_Tk the generic var token to be inserted
    * @return token representation
    */
    func insertValueExpr(valueReceiver_Tk: Tokens, genericVar_Tk: Tokens): Tokens

    protected func getContainerIdentifier(): String {
        return thisType.getOrThrow().getTypeName()
    }

    protected func getGenericType(): NodeFormat_Type {
        return thisType.getOrThrow().asRefType().getArgs()[0]
    }
    
    protected func getGenericTypeName(): String {
        return getGenericType().getTypeName()
    }

    public func getGenericTypeAdaptor(): JsonAdaptor {
        return adaptorFactory.getAdaptor(getGenericTypeName())
    }

    public func fromJsonValue(valueReceiver_Tk: Tokens, jsonVar_Tk: Tokens, varIdentifierName: String): Tokens {
        var containType_Tk = getType()
        var genericType_Tk = getGenericType()
        var genericReceiver = varIdentifierName + "_val"
        var genericVar_Tk = Tokens([Token(TokenKind.IDENTIFIER, genericReceiver)])
        var itemVar_Tk = Tokens([Token(TokenKind.IDENTIFIER, varIdentifierName + "_item")])

        // genericAdaptor needs to be fetched and mutated after the token composition above finished,
        // since the collection adaptor are reused (fx between HashSet<Hashset<String>> & Hashset<String>)
        // and mutating the state will cause unwanted side effect.
        // Another solution would be creating new adaptors everytime, but that is not memory efficient
        var genericAdaptor = adaptorFactory.getAdaptor(getGenericTypeName())
        genericAdaptor.setType(genericType_Tk)     
        var genericValueProcess_Tk = genericAdaptor.fromJsonValue(genericVar_Tk, itemVar_Tk, genericReceiver)
        var insertValueExpr_Tk = insertValueExpr(valueReceiver_Tk, genericVar_Tk)
        
        return quote(
            $valueReceiver_Tk = $containType_Tk()
            var $genericVar_Tk: $genericType_Tk

            for ($itemVar_Tk in $jsonVar_Tk.asArray().getItems()) {                
                $genericValueProcess_Tk
                $insertValueExpr_Tk
            }
        )
    }

    public func toJsonValueFunc(valueSource_Tk: Tokens, funcName_Tk: Tokens, varIdentifierName: String): Tokens {
        var genericValueFuncName_TK = Tokens([Token(TokenKind.IDENTIFIER, "getVal_" + getContainerIdentifier())])
        var genericReceiver = varIdentifierName + "_val"
        var elementVar_Tk = Tokens([Token(TokenKind.IDENTIFIER, genericReceiver)])

        // genericAdaptor needs to be fetched and mutated after the token composition above finished,
        // since the collection adaptor are reused (fx between HashSet<Hashset<String>> & Hashset<String>)
        // and mutating the state will cause unwanted side effect.
        // Another solution would be creating new adaptors everytime, but that is not memory efficient        
        var genericAdaptor = adaptorFactory.getAdaptor( getGenericTypeName())
        genericAdaptor.setType(getGenericType())
        var geneticValueFunc_Tk = genericAdaptor.toJsonValueFunc(elementVar_Tk, genericValueFuncName_TK, genericReceiver)

        return quote(
            func $funcName_Tk() {
                var jsonArray = JsonArray()            
                for ($elementVar_Tk in $valueSource_Tk) {
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
    public init(defalutValueExprStore: DefaultValueExprStore, adaptorFactory: JsonAdaptorFactory) {
        super(defalutValueExprStore, adaptorFactory)
    }
    
    protected func insertValueExpr(valueReceiver_Tk: Tokens, genericVar_Tk: Tokens): Tokens {
        return quote(
            $valueReceiver_Tk.append($genericVar_Tk)
        )
    }
}

class HashSetAdaptor <: JsonCollectionAdaptorImpl {
    public init(defalutValueExprStore: DefaultValueExprStore, adaptorFactory: JsonAdaptorFactory) {
        super(defalutValueExprStore, adaptorFactory)
    }
    
    protected func insertValueExpr(valueReceiver_Tk: Tokens, genericVar_Tk: Tokens): Tokens {
        return quote(
            $valueReceiver_Tk.put($genericVar_Tk)
        )
    }
}


