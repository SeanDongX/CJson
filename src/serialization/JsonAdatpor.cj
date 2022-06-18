macro package serialization

interface JsonAdaptor {
    
    /*
    / Composes an expression with jsonValue as input for deserialization
    / for example: quote($jsonValueToken.asString().getOrThrow().getValue())
    */
    func fromJsonValue(jsonToken: Tokens): Tokens
    
    /*
    / Composes an expression with identifier as input for serialization
    / for example: quote(JsonString(this.$identifier))
    */
    func toJsonValue(identifier: Token): Tokens
}

class StringAdaptor <: JsonAdaptor {
    public func fromJsonValue(jsonToken: Tokens): Tokens {
        return quote(
            $jsonToken.asString().getOrThrow().getValue()
        )
    }
    
    public func toJsonValue(identifier: Token): Tokens {
        return quote(
            JsonString(this.$identifier)
        )
    }
}

class BoolAdaptor <: JsonAdaptor {
    public func fromJsonValue(jsonToken: Tokens): Tokens {
        return quote(
            $jsonToken.asBool().getOrThrow().getValue()
        )
    }
    
    public func toJsonValue(identifier: Token): Tokens {
        return quote(
            JsonBool(this.$identifier)
        )
    }
}

class IntAdaptor <: JsonAdaptor {
    public func fromJsonValue(jsonToken: Tokens): Tokens {
        return quote(
            $jsonToken.asInt().getOrThrow().getValue()
        )
    }
    
    public func toJsonValue(identifier: Token): Tokens {
        return quote(
            JsonInt(this.$identifier)
        )
    }
}

class FloatAdaptor <: JsonAdaptor {
    public func fromJsonValue(jsonToken: Tokens): Tokens {
        return quote(
            $jsonToken.asFloat().getOrThrow().getValue()
        )
    }
    
    public func toJsonValue(identifier: Token): Tokens {
        return quote(
            JsonFloat(this.$identifier)
        )
    }
}