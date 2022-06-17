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

        try {

            let tokens: Tokens = match(typeInfo) {
                case "String" =>  quote(
                    ret.$identifier = jsonObject.get($mappedNameValue).asString().getOrThrow().getValue()
                )
                case "Bool" =>  quote(
                    ret.$identifier = jsonObject.get($mappedNameValue).asBool().getOrThrow().getValue()
                )
                case "Int64" => quote(
                    ret.$identifier = jsonObject.get($mappedNameValue).asInt().getOrThrow().getValue()                
                )
                case "Float64" => quote(
                    ret.$identifier = jsonObject.get($mappedNameValue).asFloat().getOrThrow().getValue()                
                )
                case _ => Tokens()
            }

            return tokens

        } catch(e: NoneValueException) {
            throw Exception("Exception caught: " + name)
        }
    }
}
