macro package serialization

class ClassJsonDeserilizer <: ClassProcessor {
    public func makeFromJsonFunc(classIdentity_Tk: Token, filedInfoList: ArrayList<NodeFormat_VarDecl>): Tokens {
        
        var jsonOjbectToken = Token(TokenKind.IDENTIFIER, "jsonObject")

        return quote(
            public static func fromJson(json: String): $classIdentity_Tk {
                var $jsonOjbectToken = JsonParser().parse(json).asObject().getOrThrow()
                
                var ret = $classIdentity_Tk()

                $(parseJsonFields(filedInfoList, jsonOjbectToken))
                
                return ret
            }
        )
    }

    private func parseJsonFields(filedInfoList: ArrayList<NodeFormat_VarDecl>, jsonOjbect_Tk: Token): Tokens {
        var fieldParseToken = Tokens()
        
        for(fieldInfo in filedInfoList) {
            fieldParseToken = fieldParseToken +  parseJsonFiled(fieldInfo, jsonOjbect_Tk)              
        }

        return fieldParseToken
    }

    private func parseJsonFiled(var_Tk: NodeFormat_VarDecl, jsonOjbectVar_Tk: Token): Tokens {
        //TODO: get type from getType() or init Func()
        let (identifier, name, typeName) = getFieldInfo(var_Tk)
        var mappedNameValue = getMappedName(name)
        
        var nodeJson_Tk = quote($jsonOjbectVar_Tk.get($mappedNameValue))
        var valueReveiverTK = quote(ret.$identifier)
        try {            
            var adaptor = globalConfig.adaptorFactry.getAdaptor(typeName)
            adaptor.setType(var_Tk.getType().getOrThrow())
    
            return adaptor.fromJsonValue(valueReveiverTK, nodeJson_Tk, name)
        } catch(exp: AdaptorMissingException) {
            //TODO: check if class is marked with JsonSerializable
            var classNameToken = Token(TokenKind.IDENTIFIER, typeName)
            return quote(                    
                $valueReveiverTK = $classNameToken.fromJson($nodeJson_Tk.toString())
            )

            //throw AdaptorMissingException("Adaptor missing for ${identifier.value} of type ${typeName}")
        }

        return Tokens()

    }
}
