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

        try {
            var adaptor = globalConfig.adaptorFactry.getAdaptor(typeName)
            adaptor.setType(fieldInfo.getType().getOrThrow())
        
            var jsonValueFuncName_Tk = Tokens([Token(TokenKind.IDENTIFIER, "getValue_" + identifier.value)])
            var jsonValueFunc_Tk = adaptor.toJsonValueFunc(quote(this.$identifier), jsonValueFuncName_Tk, identifier.value)
            return quote(
                //define a func to getValue in place
                $jsonValueFunc_Tk

                //invoke the func
                map.put($mappedNameValue, $jsonValueFuncName_Tk())
            )

        } catch(exp: AdaptorMissingException) {
            return quote(                    
                map.put($mappedNameValue, JsonString(this.$identifier.toJson()))
            )
            throw AdaptorMissingException("Adaptor missing for ${identifier.value} of type ${typeName}")
        }
    }
}