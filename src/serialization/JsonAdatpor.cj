macro package serialization

interface JsonAdaptor {
    
    func setType(thisType: NodeFormat_Type): Unit

    /*
    / Composes an expression with jsonValue as input for deserialization
    / for example: quote($valueReceiver = $jsonValueToken.asString().getOrThrow().getValue())
    */
    func fromJsonValue(valueReceiver: Tokens, jsonVar: Tokens, varIdentifierName: String): Tokens
    
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
}

class StringAdaptor <: Adaptor & JsonAdaptor {
    public func fromJsonValue(valueReceiver: Tokens, jsonVar: Tokens, varIdentifierName: String): Tokens {
        return quote(
           $valueReceiver = $jsonVar.asString().getOrThrow().getValue()
        )
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
    public func fromJsonValue(valueReceiver: Tokens, jsonVar: Tokens, varIdentifierName: String): Tokens {
        return quote(
           $valueReceiver = $jsonVar.asBool().getOrThrow().getValue()
        )
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
    public func fromJsonValue(valueReceiver: Tokens, jsonVar: Tokens, varIdentifierName: String): Tokens {
        return quote(
           $valueReceiver = $jsonVar.asInt().getOrThrow().getValue()
        )
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

    public func fromJsonValue(valueReceiver: Tokens, jsonVar: Tokens, varIdentifierName: String): Tokens {
        return quote(
           $valueReceiver = $jsonVar.asFloat().getOrThrow().getValue()
        )
    }

    public func toJsonValueFunc(valueVar_Tk: Tokens, funcName_Tk: Tokens, varIdentifierName: String): Tokens {
        return quote(
            func $funcName_Tk() {
                return JsonFloat($valueVar_Tk)
            }
        )
    }
}