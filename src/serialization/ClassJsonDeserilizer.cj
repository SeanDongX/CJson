macro package serialization

class ClassJsonDeserilizer <: ClassProcessor {
    public func makeFromJsonFunc(classIdent: Token, filedInfoList: ArrayList<NodeFormat_VarDecl>): Tokens {
        
        var jsonOjbectToken = Token(TokenKind.IDENTIFIER, "jsonObject")

        return quote(
            public static func fromJson(json: String): $classIdent {
                var $jsonOjbectToken = JsonParser().parse(json).asObject().getOrThrow()
                
                var ret = $classIdent()

                $(parseJsonFields(filedInfoList, jsonOjbectToken))
                
                return ret
            }
        )
    }

    private func parseJsonFields(filedInfoList: ArrayList<NodeFormat_VarDecl>, jsonOjbectToken: Token): Tokens {
        var fieldParseToken = Tokens()
        
        for(fieldInfo in filedInfoList) {
            fieldParseToken = fieldParseToken +  parseJsonFiled(fieldInfo, jsonOjbectToken)              
        }

        return fieldParseToken
    }

    private func parseJsonFiled(fieldInfo: NodeFormat_VarDecl, jsonOjbectVar: Token): Tokens {
        //TODO: get type from getType() or init Func()
        let (identifier, name, typeName) = getFieldInfo(fieldInfo)
        var mappedNameValue = getMappedName(name)
        
        var nodeJson = quote($jsonOjbectVar.get($mappedNameValue))
        var valueReveiverTK = quote(ret.$identifier)
        try {            
            var adaptor = globalConfig.adaptorFactry.getAdaptor(typeName)
            adaptor.setType(fieldInfo.getType().getOrThrow())
    
            return adaptor.fromJsonValue(valueReveiverTK, nodeJson, name)
        } catch(exp: AdaptorMissingException) {
            //TODO: check if class is marked with JsonSerializable
            var classNameToken = Token(TokenKind.IDENTIFIER, typeName)
            return quote(                    
                $valueReveiverTK = $classNameToken.fromJson($nodeJson.toString())
            )

            //throw AdaptorMissingException("Adaptor missing for ${identifier.value} of type ${typeName}")
        }

        return Tokens()

    }
}
