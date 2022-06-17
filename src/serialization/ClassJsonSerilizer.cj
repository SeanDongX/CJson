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
        var fileMapToken = Tokens()
        
        for(fieldInfo in filedInfoList) {
            fileMapToken = fileMapToken + addFieldToMap(fieldInfo)   
        }

        return fileMapToken
    }

    private func addFieldToMap(fieldInfo: NodeFormat_VarDecl): Tokens {
        let (identifier, name, typeInfo) = getFieldInfo(fieldInfo)        
        var mappedNameValue = getMappedName(name)

        if (userDefinedVarMap.contains(name)) {
            mappedNameValue = userDefinedVarMap.get(name).getOrThrow()
        }

        let tokens: Tokens = match(typeInfo) {
            case "String" => quote(
                map.put($mappedNameValue, JsonString(this.$identifier))
            )
            case "Int64" => quote(
                map.put($mappedNameValue, JsonInt(this.$identifier))
            )
            case _ => Tokens()
        }

        return tokens
    }
}