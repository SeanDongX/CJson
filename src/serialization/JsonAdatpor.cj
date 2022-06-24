macro package serialization

interface JsonAdaptor {
    
    func setType(thisType: NodeFormat_Type): Unit

    /*
    / Composes an expression with jsonValue as input for deserialization
    / for example: quote($valueReceiver = $jsonValueToken.asString().getOrThrow().getValue())
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