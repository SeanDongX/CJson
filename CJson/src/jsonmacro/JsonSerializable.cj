macro package jsonmacro

from std import collection.*

import serialization.*
import serialization.adaptor.*
import serialization.common.*

/*
* Macro for inserting json serialization/deserialization func onto target class
* @param input_Tk the target class token
* @return token the expaned token representation
*/
public macro JsonSerializable(input_Tk: Tokens): Tokens {    
    let declPair = TokenVerifier.verifyClassDecl(input_Tk, Const.JSON_SERIALIZABLE_MACRO_NAME)

    var classAndStructInfo = ClassAndStructInfo()

    match(declPair) {
        case (Some(vc), None) =>
            classAndStructInfo.classModifier = vc.getModifiers()
            classAndStructInfo.classKeyWord = vc.getKeyword()
            classAndStructInfo.classIdent = vc.getIdentifier()
            classAndStructInfo.classBody = vc.getBody()
            classAndStructInfo.superTypes = vc.getSuperTypes()
            classAndStructInfo.varDeclList = checkVars(vc, globalConfig)

        case (None, Some(vs)) => 
            classAndStructInfo.classModifier = vs.getModifiers()
            classAndStructInfo.classKeyWord = vs.getKeyword()
            classAndStructInfo.classIdent = vs.getIdentifier()
            classAndStructInfo.classBody = vs.getBody()
            classAndStructInfo.superTypes = vs.getSuperTypes()
            classAndStructInfo.varDeclList = checkVars(vs, globalConfig)

        case _ => ()
    }

    try {
        return classAndStructInfo.composeWithJsonFunc(globalConfig)
    } catch(exp: AdaptorMissingException | TypeInferrenceException ) {
        throw MacroExpansionException("Exception when expending JsonSerializable at class/struct ${classAndStructInfo.classIdent.value} : " + exp.message)
    }
}


func checkVars(classDecl_Tk: FlatBufferObject, globalConfig: GlobalConfig): ArrayList<NodeFormat_VarDecl> {
    let varVisitor = ClassVarDeclVisitor(globalConfig)
    Walker.walk(classDecl_Tk, varVisitor)
    globalConfig.defaultValueMap = varVisitor.getDefaultVarValueMap()
    return varVisitor.getVarTokenList()
}