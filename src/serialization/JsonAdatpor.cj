package serialization

/*
* Interface for json adaptor
*/
public interface JsonAdaptor {
    
    /*
    * Sets the type of the adaptor
    * @param thisType the type token for the identifier, the token is used
    * for later operations when doing serializationd and deserialization
    */
    func setType(thisType: NodeFormat_Type): Unit

    /*
    * Makes token representation for deserializing the given json to pass it on to the receiver
    * @param valueReceiver_TK the receiver for the deserialized value
    * @param jsonVar_Tk the var that holds the source json value
    * @param varIdentifierName the identifier name of the receiver, using for internal namespaing
    * @return Tokens the token representation 
    */
    func fromJsonValue(valueReceiver_TK: Tokens, jsonVar_Tk: Tokens, varIdentifierName: String): Tokens
    
    /*
    / Composes a func for serialization of the valueVar, this func can be invoked later with funcName_Tk()
    / for example:
    /   return quote(
    /       func $funcName_Tk() {
    /           return JsonString($valueVar_Tk)
    /       }
    /   )
    */
    /*
    * Makes token representation for serializing the given value to json
    * @param valueVar_Tk the source of the value
    * @param funcName_Tk the predefined func name for serialization, to be used later as refence for func call
    * @param varIdentifierName the identifier name of the receiver, using for internal namespaing
    * @return Tokens the token representation 
    */
    func toJsonValueFunc(valueVar_Tk: Tokens, funcName_Tk: Tokens, varIdentifierName: String): Tokens
}

public interface DefaultValueExprStore {
    func hasValueExpr(varIdentifierName: String): Bool
    func getValueExpr(varIdentifierName: String): NodeFormat_Expr
}

open class Adaptor {
    protected var thisType: Option<NodeFormat_Type> = None
    protected var defalutValueExprStore: DefaultValueExprStore

    public init(defalutValueExprStore: DefaultValueExprStore) {
        this.defalutValueExprStore = defalutValueExprStore
    }

    
    public func setType(thisType: NodeFormat_Type) {
       this.thisType = thisType
    }

    public func getType(): NodeFormat_Type {
        return thisType.getOrThrow()
    }

    /*
    * The core operation for interface fromJsonValue func
    * @param valueReceiver_TK the receiver for the deserialized value
    * @param varIdentifierName the identifier name of the receiver, using for internal namespaing
    * @param valueParse_Tk the token repsenetation for value parsing operations
    * @return Tokens the token representation 
    */
    protected func fromJsonValueCore(valueReceiver_TK: Tokens, varIdentifierName: String, valueParse_Tk: Tokens, defaultValueAssign_Tk: Tokens): Tokens {
        var internalDefaultValueAssign_Tk = defaultValueAssign_Tk
        var hasDefaultValue = quote(false)

        if (defalutValueExprStore.hasValueExpr(varIdentifierName)) {
            hasDefaultValue = quote(true)
            internalDefaultValueAssign_Tk = quote(
                $valueReceiver_TK = $(defalutValueExprStore.getValueExpr(varIdentifierName))
            )
        }

        return quote(
            $internalDefaultValueAssign_Tk
            try {
                $valueParse_Tk
            } catch(exp: Exception) {
                if (! $hasDefaultValue) {
                    throw exp
                }
            }
        )
    }
    
}

class StringAdaptor <: Adaptor & JsonAdaptor {
    public init(defalutValueExprStore: DefaultValueExprStore) {
        super(defalutValueExprStore)
    }

    public func fromJsonValue(valueReceiver_Tk: Tokens, jsonVar_Tk: Tokens, varIdentifierName: String): Tokens {
        super.fromJsonValueCore(valueReceiver_Tk, varIdentifierName,
            quote( $valueReceiver_Tk = $jsonVar_Tk.asString().getValue() ),
            quote( $valueReceiver_Tk = "" ))
    }
    
    public func toJsonValueFunc(valueVar_Tk: Tokens, funcName_Tk: Tokens, varIdentifierName: String): Tokens {
        return quote(
            func $funcName_Tk() {
                return JsonString($valueVar_Tk)
            }
        )
    }
}

class BoolAdaptor <: Adaptor & JsonAdaptor {
    public init(defalutValueExprStore: DefaultValueExprStore) {
        super(defalutValueExprStore)
    }

    public func fromJsonValue(valueReceiver_Tk: Tokens, jsonVar_Tk: Tokens, varIdentifierName: String): Tokens {
        super.fromJsonValueCore(valueReceiver_Tk, varIdentifierName, 
            quote( $valueReceiver_Tk = $jsonVar_Tk.asBool().getValue() ),
            quote( $valueReceiver_Tk = false ))
    }
    
    public func toJsonValueFunc(valueVar_Tk: Tokens, funcName_Tk: Tokens, varIdentifierName: String): Tokens {
        return quote(
            func $funcName_Tk() {
                return JsonBool($valueVar_Tk)
            }
        )
    }
}

class IntAdaptor <: Adaptor & JsonAdaptor {
    public init(defalutValueExprStore: DefaultValueExprStore) {
        super(defalutValueExprStore)
    }
    
    public func fromJsonValue(valueReceiver_Tk: Tokens, jsonVar_Tk: Tokens, varIdentifierName: String): Tokens {
        super.fromJsonValueCore(valueReceiver_Tk, varIdentifierName, 
            quote( $valueReceiver_Tk = $jsonVar_Tk.asInt().getValue() ),
            quote( $valueReceiver_Tk = 0 ))
    }

    public func toJsonValueFunc(valueVar_Tk: Tokens, funcName_Tk: Tokens, varIdentifierName: String): Tokens {
        return quote(
            func $funcName_Tk() {
                return JsonInt($valueVar_Tk)
            }
        )
    }
}

class FloatAdaptor <: Adaptor & JsonAdaptor {
    public init(defalutValueExprStore: DefaultValueExprStore) {
        super(defalutValueExprStore)
    }
    
    public func fromJsonValue(valueReceiver_Tk: Tokens, jsonVar_Tk: Tokens, varIdentifierName: String): Tokens {
        super.fromJsonValueCore(valueReceiver_Tk, varIdentifierName, 
            quote( $valueReceiver_Tk = $jsonVar_Tk.asFloat().getValue() ),
            quote( $valueReceiver_Tk = 0.0 ))
    }

    public func toJsonValueFunc(valueVar_Tk: Tokens, funcName_Tk: Tokens, varIdentifierName: String): Tokens {
        return quote(
            func $funcName_Tk() {
                return JsonFloat($valueVar_Tk)
            }
        )
    }
}