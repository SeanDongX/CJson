macro package serialization

interface JsonAdaptor {
    
    /*
    / Composes an expression with jsonValue as input for deserialization
    / for example: quote($valueReceiver = $jsonValueToken.asString().getOrThrow().getValue())
    */
    func fromJsonValue(valueReceiver: Tokens, jsonVar: Tokens): Tokens
    
    /*
    / Composes a func for serialization of the valueVar, this func can be invoked later with funcName_Tk()
    / for example:
    /   return quote(
    /       func $funcName_Tk() {
    /           return JsonString($valueVar_Tk)
    /       }
    /   )
    */
    func toJsonValueFunc(valueVar_Tk: Tokens, funcName_Tk: Tokens): Tokens
}

class StringAdaptor <: JsonAdaptor {
    public func fromJsonValue(valueReceiver: Tokens, jsonVar: Tokens): Tokens {
        return quote(
           $valueReceiver = $jsonVar.asString().getOrThrow().getValue()
        )
    }
    
    public func toJsonValueFunc(valueVar_Tk: Tokens, funcName_Tk: Tokens): Tokens {
        return quote(
            func $funcName_Tk() {
                return JsonString($valueVar_Tk)
            }
        )
    }
}

class BoolAdaptor <: JsonAdaptor {
    public func fromJsonValue(valueReceiver: Tokens, jsonVar: Tokens): Tokens {
        return quote(
           $valueReceiver = $jsonVar.asBool().getOrThrow().getValue()
        )
    }
    
    public func toJsonValueFunc(valueVar_Tk: Tokens, funcName_Tk: Tokens): Tokens {
        return quote(
            func $funcName_Tk() {
                return JsonBool($valueVar_Tk)
            }
        )
    }
}

class IntAdaptor <: JsonAdaptor {
        public func fromJsonValue(valueReceiver: Tokens, jsonVar: Tokens): Tokens {
        return quote(
           $valueReceiver = $jsonVar.asInt().getOrThrow().getValue()
        )
    }

    public func toJsonValueFunc(valueVar_Tk: Tokens, funcName_Tk: Tokens): Tokens {
        return quote(
            func $funcName_Tk() {
                return JsonInt($valueVar_Tk)
            }
        )
    }
}

class FloatAdaptor <: JsonAdaptor {

    public func fromJsonValue(valueReceiver: Tokens, jsonVar: Tokens): Tokens {
        return quote(
           $valueReceiver = $jsonVar.asFloat().getOrThrow().getValue()
        )
    }

    public func toJsonValueFunc(valueVar_Tk: Tokens, funcName_Tk: Tokens): Tokens {
        return quote(
            func $funcName_Tk() {
                return JsonFloat($valueVar_Tk)
            }
        )
    }
}