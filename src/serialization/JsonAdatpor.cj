macro package serialization

interface JsonAdaptor {
    
    /*
    / Composes an expression with jsonValue as input for deserialization
    / for example: quote($valueReceiver = $jsonValueToken.asString().getOrThrow().getValue())
    */
    func fromJsonValue(valueReceiver: Tokens, jsonVar: Tokens): Tokens
    
    /*
    / Composes an expression with identifier as input for serialization
    / for example: quote($jsonMapVar.put($keyVar, JsonString($valueVar)))
    */
    func toJsonValue(jsonMapVar: Tokens,  keyVar: Tokens, valueVar: Tokens): Tokens
}

interface CollectionJsonAdaptor <: JsonAdaptor {
    func setGenericType(typeName: String): Unit
    func setContainerType(typeName: String): Unit
    func fromJsonValue(receipentToken: Tokens, jsonToken: Tokens): Tokens
    func toJsonValue(receipentToken: Tokens, keyToken: Tokens, jsonToken: Tokens): Tokens
}

class StringAdaptor <: JsonAdaptor {
    public func fromJsonValue(valueReceiver: Tokens, jsonVar: Tokens): Tokens {
        return quote(
           $valueReceiver = $jsonVar.asString().getOrThrow().getValue()
        )
    }
    
    public func toJsonValue(jsonMapVar: Tokens,  keyVar: Tokens, valueVar: Tokens): Tokens {
        return quote(
            $jsonMapVar.put($keyVar, JsonString($valueVar)) 
        )
    }
}

class BoolAdaptor <: JsonAdaptor {
    public func fromJsonValue(valueReceiver: Tokens, jsonVar: Tokens): Tokens {
        return quote(
           $valueReceiver = $jsonVar.asBool().getOrThrow().getValue()
        )
    }
    
    public func toJsonValue(jsonMapVar: Tokens,  keyVar: Tokens, valueVar: Tokens): Tokens {
        return quote(
            $jsonMapVar.put($keyVar, JsonBool($valueVar)) 
        )
    }
}

class IntAdaptor <: JsonAdaptor {
        public func fromJsonValue(valueReceiver: Tokens, jsonVar: Tokens): Tokens {
        return quote(
           $valueReceiver = $jsonVar.asInt().getOrThrow().getValue()
        )
    }
    
    public func toJsonValue(jsonMapVar: Tokens,  keyVar: Tokens, valueVar: Tokens): Tokens {
        return quote(
            $jsonMapVar.put($keyVar, JsonInt($valueVar)) 
        )
    }
}

class FloatAdaptor <: JsonAdaptor {

    public func fromJsonValue(valueReceiver: Tokens, jsonVar: Tokens): Tokens {
        return quote(
           $valueReceiver = $jsonVar.asFloat().getOrThrow().getValue()
        )
    }
    
    public func toJsonValue(jsonMapVar: Tokens,  keyVar: Tokens, valueVar: Tokens): Tokens {
        return quote(
            $jsonMapVar.put($keyVar, JsonFloat($valueVar)) 
        )
    }
}