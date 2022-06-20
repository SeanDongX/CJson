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
        let (identifier, name, typeName) = getFieldInfo(fieldInfo)        
        var mappedNameValue = getMappedName(name)

        if (globalConfig.userDefinedVarMap.contains(name)) {
            mappedNameValue = globalConfig.userDefinedVarMap.get(name).getOrThrow()
        }

        try {
            var adaptor = globalConfig.adaptorFactry.getAdaptor(typeName)
            
            if (adaptor is CollectionJsonAdaptor) {
                let valueParseExpr = (adaptor as CollectionJsonAdaptor).getOrThrow().toJsonValue(quote(map), quote($mappedNameValue), quote(this.$identifier))
                return quote(                    
                    $valueParseExpr
                )

            } else {
                let valueExpr = globalConfig.adaptorFactry.getAdaptor(typeName).toJsonValue(identifier)                        
                return quote(
                    map.put($mappedNameValue, $valueExpr)
                )
            }
        } catch(exp: AdaptorMissingException) {
            return quote(                    
                map.put($mappedNameValue, JsonString(this.$identifier.toJson()))
            )
            throw AdaptorMissingException("Adaptor missing for ${identifier.value} of type ${typeName}")
        }
    }
}