macro package serialization

open class ClassProcessor {
    protected func getFieldInfo(vark_Tk: NodeFormat_VarDecl): (Token, String, String) {
        return vark_Tk.getVarInfo()
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
