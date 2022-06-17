macro package serialization

class ClassMemeberDeclVisitor <: Visitor {
    private var fileInfoList: ArrayList<NodeFormat_VarDecl> = ArrayList()

    public func getFiledInfo(): ArrayList<NodeFormat_VarDecl> {
        return fileInfoList
    }

    override public func visitDecl(decl: Decl): Bool {
        if (decl.isFuncDecl()) {
            //stop processing func so it won't include var declaration inside funcs
            return false
        }

        if (decl.isVarDecl()) {
            fileInfoList.add(decl.asVarDecl())
        }
        
        return true
    }
}
