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

interface CollectionJsonAdaptor <: JsonAdaptor {
    func setGenericType(typeName: String): Unit
    func setContainerType(typeName: String): Unit
    func fromJsonValue(receipentToken: Tokens, jsonToken: Tokens): Tokens
    func toJsonValue(receipentToken: Tokens, keyToken: Tokens, jsonToken: Tokens): Tokens
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

class ArrayAdaptor <: CollectionJsonAdaptor {
    private var containerType: String = "ArrayList"
    private var genericType: String = "String"

    public func setContainerType(typeName: String) {
        containerType = typeName
    }

    public func setGenericType(typeName: String) {
        genericType = typeName
    }

    public func fromJsonValue(receipentToken: Tokens, jsonToken: Tokens): Tokens {
        var adaptor = StringAdaptor()
        var containerTypeIdentifier = Token(TokenKind.IDENTIFIER, containerType)
        var genericTypeIdentifier = Token(TokenKind.IDENTIFIER, genericType)
        
        return quote(
            $receipentToken = $containerTypeIdentifier<$genericTypeIdentifier>()
            for (jsonValue in $jsonToken.asArray().getOrThrow().getItems()) {
                ////TODO: User adaptor to evaluate: $(adaptor.fromJsonValue(jsonValue)
                ret.array.add(jsonValue.asString().getOrThrow().getValue())
            }
        ) 
    }
    
    //TODO: remove
    public func fromJsonValue(jsonToken: Tokens): Tokens {
        return Tokens()
    }

    public func toJsonValue(mapToken: Tokens,  keyToken: Tokens, identifier: Tokens): Tokens {
        return quote(
            var jsonArray = JsonArray()            
            for (element in $identifier) {
                ////TODO: User adaptor to evaluate: $(adaptor.toJsonValue(jsonValue)
                jsonArray.add(JsonString(element))
            }

            $mapToken.put($keyToken, jsonArray)
        )
    }

    //TODO: remove
    public func toJsonValue(identifier: Token): Tokens {        
        return Tokens()
    }
}