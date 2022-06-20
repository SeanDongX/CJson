macro package serialization

open class ClassProcessor {
    protected func getFieldInfo(fieldInfo: NodeFormat_VarDecl): (Token, String, String) {
        let identifier = fieldInfo.getIdentifier()
        let name = identifier.value
        var typeName: String

        try {
            typeName = match(fieldInfo.getType()) {
                case Some(v) where v.isRefType() => v.asRefType().getIdentifier().value
                case Some(v) where v.isPrimitiveType() => v.asPrimitiveType().getPrimitive().value
                case _ => throw TypeInferrenceException("Field ${name} must be declared with a specific type instead of using a inferred type")
            }
            //typeName = fieldInfo.getType().getOrThrow().asRefType().getIdentifier().value
        } catch (exp: NoneValueException) {
            throw TypeInferrenceException("Field ${name} must be declared with a specific type instead of using a inferred type")
        }
        
        return (identifier, name, typeName)
    }

    protected func getMappedName(name: String): String {
        var mappedNameValue = name
        if (globalConfig.userDefinedVarMap.contains(name)) {
            mappedNameValue = globalConfig.userDefinedVarMap.get(name).getOrThrow()
        }
        
        return mappedNameValue
    }
}
