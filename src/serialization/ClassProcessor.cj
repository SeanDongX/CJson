macro package serialization

open class ClassProcessor {
    protected func getFieldInfo(fieldInfo: NodeFormat_VarDecl): (Token, String, String) {
        return fieldInfo.getVarInfo()
    }

    protected func getMappedName(name: String): String {
        var mappedNameValue = name
        if (globalConfig.userDefinedVarMap.contains(name)) {
            mappedNameValue = globalConfig.userDefinedVarMap.get(name).getOrThrow()
        }
        
        return mappedNameValue
    }

    protected func getFromJson() {
        
    }
}
