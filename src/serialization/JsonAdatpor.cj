macro package serialization

/*
* Interface for json adaptor
*/
interface JsonAdaptor {
    
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

open class Adaptor {
    protected var thisType: Option<NodeFormat_Type> = None

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
    protected func fromJsonValueCore(valueReceiver_TK: Tokens, varIdentifierName: String, valueParse_Tk: Tokens): Tokens {
        var defaultValueAssign_Tk = Tokens()
        var hasDefaultValue = quote(false)

        if (globalConfig.defaultValueMap.contains(varIdentifierName)) {
            hasDefaultValue = quote(true)
            defaultValueAssign_Tk = quote(
                $valueReceiver_TK = $(globalConfig.defaultValueMap.get(varIdentifierName).getOrThrow())
            )
        }

        return quote(
            $defaultValueAssign_Tk
            try {
                $valueParse_Tk
            } catch(exp: Exception) {
                //swollow exception if default value is assigned
                if (!$hasDefaultValue) {
                    throw exp
                }
            }
        )
    }
    
}

class StringAdaptor <: Adaptor & JsonAdaptor {
    public func fromJsonValue(valueReceiver_TK: Tokens, jsonVar_Tk: Tokens, varIdentifierName: String): Tokens {
        super.fromJsonValueCore(valueReceiver_TK, varIdentifierName, 
            quote($valueReceiver_TK = $jsonVar_Tk.asString().getOrThrow().getValue()))
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
    public func fromJsonValue(valueReceiver_Tk: Tokens, jsonVar_Tk: Tokens, varIdentifierName: String): Tokens {
        super.fromJsonValueCore(valueReceiver_Tk, varIdentifierName, 
            quote($valueReceiver_Tk = $jsonVar_Tk.asBool().getOrThrow().getValue()))
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
    public func fromJsonValue(valueReceiver_Tk: Tokens, jsonVar_Tk: Tokens, varIdentifierName: String): Tokens {
        super.fromJsonValueCore(valueReceiver_Tk, varIdentifierName, 
            quote($valueReceiver_Tk = $jsonVar_Tk.asInt().getOrThrow().getValue()))
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
    public func fromJsonValue(valueReceiver_Tk: Tokens, jsonVar_Tk: Tokens, varIdentifierName: String): Tokens {
        super.fromJsonValueCore(valueReceiver_Tk, varIdentifierName, 
            quote($valueReceiver_Tk = $jsonVar_Tk.asFloat().getOrThrow().getValue()))
    }

    public func toJsonValueFunc(valueVar_Tk: Tokens, funcName_Tk: Tokens, varIdentifierName: String): Tokens {
        return quote(
            func $funcName_Tk() {
                return JsonFloat($valueVar_Tk)
            }
        )
    }
}