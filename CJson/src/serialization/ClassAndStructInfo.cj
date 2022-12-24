package serialization

public struct ClassAndStructInfo {
    public var varDeclList = ArrayList<NodeFormat_VarDecl>()
    public var classModifier = Tokens()
    public var classKeyWord = Token()
    public var classIdent = Token()
    public var classBody = Array<NodeFormat_Decl>()
    public var superTypes = Array<NodeFormat_Type>()

    public func composeWithJsonFunc(globalConfig: GlobalConfig) {
        let fromJsonFunc = ClassJsonDeserilizer(globalConfig).makeFromJsonFunc(classIdent, varDeclList)
        let toJsonFunc = ClassJsonSerilizer(globalConfig).makeToJsonFunc(varDeclList)

        //reset global config next class
        globalConfig.reset()
        
        var superTypeExpr = Tokens()
        if (superTypes.size != 0) {
            superTypeExpr = quote(<: $superTypes & IJsonSerializable<$classIdent>)
        } else {
            superTypeExpr = quote(<: IJsonSerializable<$classIdent>)
        }

        return quote(
            $classModifier $classKeyWord $classIdent $superTypeExpr {
                $classBody
                $fromJsonFunc
                $toJsonFunc
            }
        )
    }
}