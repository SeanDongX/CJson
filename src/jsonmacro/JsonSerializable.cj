macro package jsonmacro

from std import ast.*
from std import collection.*
from encoding import json.*

import serialization.*

/*
* Macro for inserting json serialization/deserialization func onto target class
* @param input_Tk the target class token
* @return token the expaned token representation
*/
public macro JsonSerializable(input_Tk: Tokens): Tokens {    
    let decl = TokenVerifier.verifyClassDecl(input_Tk, Const.JSON_SERIALIZABLE_MACRO_NAME)
    
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
    let varVisitor = ClassVarDeclVisitor()
    Walker.walk(classDecl_Tk, varVisitor)
    globalConfig.defaultValueMap = varVisitor.getDefaultVarValueMap()
    return varVisitor.getVarTokenList()
}
