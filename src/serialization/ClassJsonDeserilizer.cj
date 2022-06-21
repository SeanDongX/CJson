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
        
        try {            
            var adaptor = globalConfig.adaptorFactry.getAdaptor(typeName)
            var input = quote(ret.$identifier)
            if (adaptor is JsonCollectionAdaptor) {
                //todo: set collection generic type
            }

            return adaptor.fromJsonValue(quote(ret.$identifier), quote($jsonOjbectVar.get($mappedNameValue)))
        } catch(exp: AdaptorMissingException) {
            var classNameToken = Token(TokenKind.IDENTIFIER, typeName)
            return quote(                    
                ret.$identifier = $classNameToken.fromJson($jsonOjbectVar.toString())
            )

            //throw AdaptorMissingException("Adaptor missing for ${identifier.value} of type ${typeName}")
        }

        return Tokens()

    }
}
