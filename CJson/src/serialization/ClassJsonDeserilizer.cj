package CJson.serialization

internal import CJson.serialization.common.*
/*
* Serializer of json for target class
*/
public class ClassJsonDeserilizer <: ClassProcessor {

    public init(globalConfig: GlobalConfig) {
        super(globalConfig)
    }

    /*
    * Makes fromJson() func of target class
    *
    * @param classIdentity_Tk the Identifier token for target class
    * @param var_Tk_List the list for memeber var token of the target class
    * @return Tokens the fromJson() func of target class represented in tokens
    */  
    public func makeFromJsonFunc(classIdentity_Tk: Token, var_Tk_List: ArrayList<VarDecl>): Tokens {
        
        var jsonOjbectToken = Token(TokenKind.IDENTIFIER, "jsonObject")

        return quote(
            public static func fromJson(json: String): $classIdentity_Tk {
                var $jsonOjbectToken = JsonValue.fromStr(json).asObject()
                
                var ret = $classIdentity_Tk()

                $(parseJsonFields(var_Tk_List, jsonOjbectToken))
                
                return ret
            }
        )
    }

    private func parseJsonFields(filedInfoList: ArrayList<VarDecl>, jsonOjbect_Tk: Token): Tokens {
        var fieldParseToken = Tokens()
        
        for(fieldInfo in filedInfoList) {
            fieldParseToken = fieldParseToken +  parseJsonFiled(fieldInfo, jsonOjbect_Tk)              
        }

        return fieldParseToken
    }

    private func parseJsonFiled(var_Tk: VarDecl, jsonOjbectVar_Tk: Token): Tokens {
        //TODO: get type from getType() or init Func()
        let (identifier, name, typeName) = getVarInfo(var_Tk)
        var mappedNameValue = getMappedName(name)
        
        var nodeJson_Tk = quote($jsonOjbectVar_Tk.get($mappedNameValue).getOrThrow())
        var valueReveiverTK = quote(ret.$identifier)
        try {            
            var adaptor = globalConfig.adaptorFactry.getAdaptor(typeName)
            adaptor.setType(var_Tk.declType)
    
            return adaptor.fromJsonValue(valueReveiverTK, nodeJson_Tk, name)
        } catch(exp: AdaptorMissingException) {
            //TODO: check if class is marked with JsonSerializable
            var classNameToken = Token(TokenKind.IDENTIFIER, typeName)
            return quote(                    
                $valueReveiverTK = $classNameToken.fromJson($nodeJson_Tk.toString())
            )

            //throw AdaptorMissingException("Adaptor missing for ${identifier.value} of type ${typeName}")
        }
    }
}
