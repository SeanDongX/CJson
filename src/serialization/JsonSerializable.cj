macro package serialization

from std import ast.*
from std import collection.*
from encoding import json.*

let userDefinedVarMap : HashMap<String, String> = HashMap()

public macro JsonSerializable(input: Tokens): Tokens {
    if (!ParseDecl(input).isClassDecl()) {
        throw Exception("JsonSerializable macro is only valid for class")
    }

    let decl = ParseDecl(input).asClassDecl()
    let classModifier = decl.getModifiers()
    let classKeyWord = decl.getKeyword()
    let classIdent = decl.getIdentifier()
    let classBody = decl.getBody()
    let superTypes = decl.getSuperTypes()
    let varDeclList = checkVars(decl)
    let fromJsonFunc = ClassJsonDeserilizer().makeFromJsonFunc(classIdent, varDeclList)
    let toJsonFunc = ClassJsonSerilizer().makeToJsonFunc(varDeclList)

    //clear map for the next class
    userDefinedVarMap.clear()
    
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
