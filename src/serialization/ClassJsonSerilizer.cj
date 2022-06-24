macro package serialization

class ClassJsonSerilizer <: ClassProcessor {
    
    /*
    * Makes  toJsonObject() and toJson() func of target class
    *
    * @param var_Tk_List the list for memeber var token of the target class
    * @return Tokens the toJsonObject() and toJson() func of target class represented in tokens
    */
    public func makeToJsonFunc(var_Tk_List: ArrayList<NodeFormat_VarDecl>): Tokens {
        
        return quote(
            public func toJsonObject(): JsonObject {
                var map: HashMap<String, JsonValue> = HashMap()

                $(composeMap(var_Tk_List))
                
                return JsonObject(map)
            }

            public func toJson(): String {
                toJsonObject().toString()
            }
        )
    }

    private func composeMap(var_Tk_List: ArrayList<NodeFormat_VarDecl>): Tokens {
        var fieldMapToken = Tokens()
        
        for(var_Tk in var_Tk_List) {
            fieldMapToken = fieldMapToken + addFieldToMap(var_Tk)   
        }

        return fieldMapToken
    }

    private func addFieldToMap(var_Tk: NodeFormat_VarDecl): Tokens {
        let (identifier, name, typeName) = getVarInfo(var_Tk)        
        var mappedNameValue = getMappedName(name)

        try {
            var adaptor = globalConfig.adaptorFactry.getAdaptor(typeName)
            adaptor.setType(var_Tk.getType().getOrThrow())
        
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
                map.put($mappedNameValue, this.$identifier.toJsonObject())
            )
            throw AdaptorMissingException("Adaptor missing for ${identifier.value} of type ${typeName}")
        }
    }
}