macro package serialization

from std import ast.*
from std import collection.*
from encoding import json.*

let globalConfig = GlobalConfig()

public macro JsonSerializable(input: Tokens): Tokens {    
    let decl = verifyClassDecl(input, "JsonSerializable")
    
    let classModifier = decl.getModifiers()
    let classKeyWord = decl.getKeyword()
    let classIdent = decl.getIdentifier()
    let classBody = decl.getBody()
    let superTypes = decl.getSuperTypes()
    let varDeclList = checkVars(decl)
    let fromJsonFunc = ClassJsonDeserilizer().makeFromJsonFunc(classIdent, varDeclList)
    let toJsonFunc = ClassJsonSerilizer().makeToJsonFunc(varDeclList)

    //reset global config next class
    globalConfig.reset()
    
    return quote(
        $classModifier $classKeyWord $classIdent <: $superTypes {
            $classBody
            $fromJsonFunc
            $toJsonFunc
        }
    )
}

func checkVars(classDecl: NodeFormat_ClassDecl): ArrayList<NodeFormat_VarDecl> {
    let varVisitor = ClassMemeberDeclVisitor()
    Walker.walk(classDecl, varVisitor)
    return varVisitor.getFiledInfo()
}
