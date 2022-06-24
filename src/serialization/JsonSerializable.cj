macro package serialization

from std import ast.*
from std import collection.*
from encoding import json.*

let globalConfig = GlobalConfig()

public macro JsonSerializable(input_Tk: Tokens): Tokens {    
    let decl = verifyClassDecl(input_Tk, "JsonSerializable")
    
    let classModifier = decl.getModifiers()
    let classKeyWord = decl.getKeyword()
    let classIdent = decl.getIdentifier()
    let classBody = decl.getBody()
    let superTypes = decl.getSuperTypes()

    try {
        let varDeclList = checkVars(decl)
        let fromJsonFunc = ClassJsonDeserilizer().makeFromJsonFunc(classIdent, varDeclList)
        let toJsonFunc = ClassJsonSerilizer().makeToJsonFunc(varDeclList)

        //reset global config next class
        globalConfig.reset()
        
        var superTypeExpr = Tokens()
        if (superTypes.size() != 0) {
            superTypeExpr = quote(<: $superTypes)
        }

        return quote(
            $classModifier $classKeyWord $classIdent $superTypeExpr {
                $classBody
                $fromJsonFunc
                $toJsonFunc
            }
        )
    } catch(exp: AdaptorMissingException | TypeInferrenceException ) {
        throw MacroExpansionException("Exception when expending JsonSerializable at class ${classIdent.value} : " + exp.getMessage())
    }
}

func checkVars(classDecl_Tk: NodeFormat_ClassDecl): ArrayList<NodeFormat_VarDecl> {
    let varVisitor = ClassMemeberDeclVisitor()
    Walker.walk(classDecl_Tk, varVisitor)
    globalConfig.defaultValueMap = varVisitor.getDefaultValueMap()
    return varVisitor.getFieldInfo()
}
