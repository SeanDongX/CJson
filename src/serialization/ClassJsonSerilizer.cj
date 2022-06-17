macro package serialization

class ClassJsonSerilizer <: ClassProcessor {
    public func makeToJsonFunc(filedInfoList: ArrayList<NodeFormat_VarDecl>): Tokens {
        return quote(
            public func toJson(): String {
                var map: HashMap<String, JsonValue> = HashMap()

                $(composeMap(filedInfoList))

                return JsonObject(map).toString()

            }
        )
    }

    private func composeMap(filedInfoList: ArrayList<NodeFormat_VarDecl>): Tokens {
        var fieldMapToken = Tokens()
        
        for(fieldInfo in filedInfoList) {
            fieldMapToken = fieldMapToken + addFieldToMap(fieldInfo)   
        }

        return fieldMapToken
    }

    private func addFieldToMap(fieldInfo: NodeFormat_VarDecl): Tokens {
        let (identifier, name, typeInfo) = getFieldInfo(fieldInfo)        
        var mappedNameValue = getMappedName(name)

        if (globalConfig.userDefinedVarMap.contains(name)) {
            mappedNameValue = globalConfig.userDefinedVarMap.get(name).getOrThrow()
        }

        let tokens: Tokens = match(typeInfo) {
            case "String" => quote(
                map.put($mappedNameValue, JsonString(this.$identifier))
            )
            case "Bool" => quote(
                map.put($mappedNameValue, JsonBool(this.$identifier))
            )
            case "Int64" => quote(
                map.put($mappedNameValue, JsonInt(this.$identifier))
            )
            case "Float64" => quote(
                map.put($mappedNameValue, JsonFloat(this.$identifier))
            )
            case _ => Tokens()
        }

        return tokens
    }
}