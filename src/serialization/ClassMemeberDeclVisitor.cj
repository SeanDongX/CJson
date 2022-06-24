macro package serialization

class ClassMemeberDeclVisitor <: Visitor {
    private var fieldInfoList: ArrayList<NodeFormat_VarDecl> = ArrayList()
    private var defaultValueMap: Map<String, NodeFormat_Expr> = HashMap()

    public func getFieldInfo(): ArrayList<NodeFormat_VarDecl> {
        return fieldInfoList
    }

    public func getDefaultValueMap(): Map<String, NodeFormat_Expr> {
        return defaultValueMap
    }

    private func setDefaultValue(varDecl_Tk: NodeFormat_VarDecl): Unit { 
        match(varDecl_Tk.getInitializer()) {
            case Some(v) => let _ = defaultValueMap.put(varDecl_Tk.getIdentifier().value, (v as NodeFormat_Expr).getOrThrow())
            case None => ()
        }
    }

    override public func visitDecl(decl: Decl): Bool {
        if (decl.isFuncDecl()) {
            //stop processing func so it won't include var declaration inside funcs
            return false
        }

        if (decl.isVarDecl()) {
            var varDecl = decl.asVarDecl()
            if (!globalConfig.ignoredVarSet.contains(varDecl.getIdentifier().value)) {
                setDefaultValue(varDecl)
                fieldInfoList.add(varDecl)
            }
            
        }
        
        return true
    }
}
