package serialization

from std import ast.*

/*
*  The visitor for class-level vars for target class
*/
public class ClassVarDeclVisitor <: Visitor {
    private var var_Tk_List: ArrayList<NodeFormat_VarDecl> = ArrayList()
    private var defaultVarValueMap: Map<String, NodeFormat_Expr> = HashMap()

    /*
    * Gets the class level var token list
    *
    * @return the list of tokens with var
    */
    public func getVarTokenList(): ArrayList<NodeFormat_VarDecl> {
        return var_Tk_List
    }

    /*
    * Gets the map that stores the default values for vars
    *
    * @return the map of default values with <VarName, DefaultVarValue>
    */
    public func getDefaultVarValueMap(): Map<String, NodeFormat_Expr> {
        return defaultVarValueMap
    }

    /*
    * Set the default value of the var
    */
    private func setDefaultValue(varDecl_Tk: NodeFormat_VarDecl): Unit { 
        match(varDecl_Tk.getInitializer()) {
            case Some(v) => let _ = defaultVarValueMap.put(varDecl_Tk.getIdentifier().value, (v as NodeFormat_Expr).getOrThrow())
            case None => ()
        }
    }

    /*
    * Implementation of class var visiting strategy, only visiting class-level vars perform related operations
    *
    * @return true if wants to continue visisting
    */
    override public func visitDecl(decl: Decl): Bool {
        if (decl.isFuncDecl()) {
            //stop processing func so it won't include var declaration inside funcs
            return false
        }

        if (decl.isVarDecl()) {
            var varDecl = decl.asVarDecl()
            if (!globalConfig.ignoredVarSet.contains(varDecl.getIdentifier().value)) {
                setDefaultValue(varDecl)
                var_Tk_List.add(varDecl)
            }
            
        }
        
        return true
    }
}
