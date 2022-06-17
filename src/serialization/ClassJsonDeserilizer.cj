macro package serialization


class ClassJsonDeserilizer <: ClassProcessor {
    public func makeFromJsonFunc(classIdent: Token, filedInfoList: ArrayList<NodeFormat_VarDecl>): Tokens {
        return quote(
            public static func fromJson(json: String): $classIdent {
                var jsonObject = JsonParser().parse(json).asObject().getOrThrow()
                
                var ret = $classIdent()

                $(parseJsonFields(filedInfoList))
                
                return ret
            }
        )
    }

    private func parseJsonFields(filedInfoList: ArrayList<NodeFormat_VarDecl>): Tokens {
        var fieldParseToken = Tokens()
        
        for(fieldInfo in filedInfoList) {
            fieldParseToken = fieldParseToken +  parseJsonFiled(fieldInfo)              
        }

        return fieldParseToken
    }

    private func parseJsonFiled(fieldInfo: NodeFormat_VarDecl): Tokens {
        //TODO: get type from getType() or init Func()
        let (identifier, name, typeInfo) = getFieldInfo(fieldInfo)
        var mappedNameValue = getMappedName(name)

        let tokens: Tokens = match(typeInfo) {
            case "String" =>  quote(
                ret.$identifier = jsonObject.get($mappedNameValue).asString().getOrThrow().getValue()
            )
            case "Int64" => quote(
                try {
                    ret.$identifier = jsonObject.get($mappedNameValue).asInt().getOrThrow().getValue()
                } catch(e: NoneValueException) {
                    throw Exception("Exception caught: " + $name)
                }
            )
            case _ => Tokens()
        }  

        return tokens
    }
}
