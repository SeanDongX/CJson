package CJson.serialization.adaptor

internal import CJson.serialization.common.*

/*
* Core implementation of JsonAdaptor for collections
*/
public abstract class JsonCollectionAdaptorImpl <: GenericAdaptor {
    public init(defalutValueExprStore: DefaultValueExprStore, adaptorFactory: JsonAdaptorFactory) {
        super(defalutValueExprStore, adaptorFactory)
    }

    /*
    * Abstract func for inserting generic var into collections
    * @param valueReceiver_Tk the collection var token to receive the generic value
    * @param genericVar_Tk the generic var token to be inserted
    * @return token representation
    */
    protected func insertValueExpr(valueReceiver_Tk: Tokens, genericVar_Tk: Tokens): Tokens

    public func fromJsonValue(valueReceiver_Tk: Tokens, jsonVar_Tk: Tokens, varIdentifierName: String): Tokens {
        var containerType_Tk = getType()
        var genericType_Tk = getGenericType()
        var genericReceiver = varIdentifierName + "_val"
        var genericVar_Tk = Tokens([Token(TokenKind.IDENTIFIER, genericReceiver)])
        var itemVar_Tk = Tokens([Token(TokenKind.IDENTIFIER, varIdentifierName + "_item")])

        var insertValueExpr_Tk = insertValueExpr(valueReceiver_Tk, genericVar_Tk)

        // genericAdaptor needs to be fetched and mutated after the token composition above finished,
        // since the collection adaptor are reused (fx between HashSet<Hashset<String>> & Hashset<String>)
        // and mutating the state will cause unwanted side effect.
        // Another solution would be creating new adaptors everytime, but that is not memory efficient
        try {
            var genericAdaptor = adaptorFactory.getAdaptor(getGenericTypeName())
            genericAdaptor.setType(genericType_Tk)
            var genericValueProcess_Tk = genericAdaptor.fromJsonValue(genericVar_Tk, itemVar_Tk, genericReceiver)
            
            return quote(
                $valueReceiver_Tk = $containerType_Tk()
                var $genericVar_Tk: $genericType_Tk

                for ($itemVar_Tk in $jsonVar_Tk.asArray().getItems()) {
                    $genericValueProcess_Tk
                    $insertValueExpr_Tk
                }
            )
        } catch(exp: AdaptorMissingException) {
            //missing registered adaptor for T, could be self implemented with fromJson
            return quote(
                $valueReceiver_Tk = $containerType_Tk()
                var $genericVar_Tk: $genericType_Tk

                for ($itemVar_Tk in $jsonVar_Tk.asArray().getItems()) {
                    $genericVar_Tk = $genericType_Tk.fromJson($itemVar_Tk.toString())
                    $insertValueExpr_Tk
                }
            )
        }
        
    }

    public func toJsonValueFunc(valueSource_Tk: Tokens, funcName_Tk: Tokens, varIdentifierName: String): Tokens {
        var genericValueFuncName_TK = Tokens([Token(TokenKind.IDENTIFIER, "getVal_" + getContainerIdentifier())])
        var genericReceiver = varIdentifierName + "_val"
        var elementVar_Tk = Tokens([Token(TokenKind.IDENTIFIER, genericReceiver)])
        // genericAdaptor needs to be fetched and mutated after the token composition above finished,
        // since the collection adaptor are reused (fx between HashSet<Hashset<String>> & Hashset<String>)
        // and mutating the state will cause unwanted side effect.
        // Another solution would be creating new adaptors everytime, but that is not memory efficient

        try {
            var genericAdaptor = adaptorFactory.getAdaptor( getGenericTypeName())
            genericAdaptor.setType(getGenericType())
            var genericValueFunc_Tk = genericAdaptor.toJsonValueFunc(elementVar_Tk, genericValueFuncName_TK, genericReceiver)

            return quote(
                func $funcName_Tk() {
                    var jsonArray = JsonArray()
                    for ($elementVar_Tk in $valueSource_Tk) {
                        //define a getValue func in place
                        $genericValueFunc_Tk

                        //invoke the func
                        jsonArray.add($genericValueFuncName_TK())
                    }

                    return jsonArray
                }
            )
        } catch(exp: AdaptorMissingException) {
            //missing registered adaptor for T, could be self implemented with fromJson
            return quote(
                 func $funcName_Tk() {
                    var jsonArray = JsonArray()
                    for ($elementVar_Tk in $valueSource_Tk) {
                        jsonArray.add($elementVar_Tk.toJsonObject())
                    }

                    return jsonArray
                }
            )
        }
        
    }
}