package CJson.serialization

public class ClassJsonSerilizer <: ClassProcessor {
    
    public init(globalConfig: GlobalConfig) {
        super(globalConfig)
    }
    
    /*
    * Makes  toJsonObject() and toJson() func of target class
    *
    * @param var_Tk_List the list for memeber var token of the target class
    * @return Tokens the toJsonObject() and toJson() func of target class represented in tokens
    */
    public func makeToJsonFunc(var_Tk_List: ArrayList<VarDecl>): Tokens {
        
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

    private func composeMap(var_Tk_List: ArrayList<VarDecl>): Tokens {
        var fieldMapToken = Tokens()
        
        for(var_Tk in var_Tk_List) {
            fieldMapToken = fieldMapToken + addFieldToMap(var_Tk)   
        }

        return fieldMapToken
    }

    private func addFieldToMap(var_Tk: VarDecl): Tokens {
        let (identifier, name, typeName, tyepArguments) = getVarInfo(var_Tk)
        var mappedNameValue = getMappedName(name)

        var identString = identifier.toTokens().toString()
        if (globalConfig.propAdaptorFactry.hasAdaptor(identString)) {
            let serializer_Tk = Token(TokenKind.IDENTIFIER, globalConfig.propAdaptorFactry.getAdaptor(identString))
            return quote(
                    map.put($mappedNameValue, $serializer_Tk.toJsonValue(this.$identifier))
            )
        } else {
            try {
                var adaptor = globalConfig.adaptorFactry.getAdaptor(typeName)
                adaptor.setType(var_Tk.declType)
            
                var jsonValueFuncName_Tk = Tokens([Token(TokenKind.IDENTIFIER, "getValue_" + identifier.value)])
                var jsonValueFunc_Tk = adaptor.toJsonValueFunc(quote(this.$identifier), jsonValueFuncName_Tk, identifier.value)
                return quote(
                    //define a func to getValue in place
                    $jsonValueFunc_Tk

                    //invoke the func
                    map.put($mappedNameValue, $jsonValueFuncName_Tk())
                )

            } catch(exp: AdaptorMissingException) {
                if (typeName.toTokens().toString().contains("Option")) {
                    return quote(
                        if (let Some(v) <- this.$identifier) {
                            map.put($mappedNameValue, v.toJsonObject())
                        } else {
                            map.put($mappedNameValue, JsonNull())
                        }
                    )
                } else {
                    return quote(                    
                        map.put($mappedNameValue, this.$identifier.toJsonObject())
                    )
                }
                //throw AdaptorMissingException("Adaptor missing for ${identifier.value} of type ${typeName}")
            }
        }
    }
}