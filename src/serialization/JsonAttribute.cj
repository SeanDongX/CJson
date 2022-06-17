macro package serialization

from std import ast.*
from encoding import json.*

public macro JsonAttribute(attr: Tokens, input: Tokens): Tokens {
    if (!ParseDecl(input).isVarDecl()) {
        throw Exception("JsonAttribute is noly allow for class level vars")
    }
    
    return quote(
        $input
        $(makeAtrritubeNameGetter(checkVarNameAttr(attr), ParseDecl(input).asVarDecl()))
    )
}

func getVarNameMapFuncToken(varDecl: NodeFormat_VarDecl): Token {
    return Token(IDENTIFIER, "get_" + varDecl.getIdentifier().value + "_name_jsonSerializer")
}

func checkVarNameAttr(attr: Tokens): String {
    var token = attr[0]
    if (token.kind == STRING_LITERAL) {
        return token.value
    } else {
        throw Exception("JsonAttribute requies a string parameter at position 0, find ${token.kind} instead") 
    }
    
}

func makeAtrritubeNameGetter(userDefinedName: String, varDecl: NodeFormat_VarDecl): Tokens {
    var fucnNameIdent = getVarCustomNameGetterFuncToken(varDecl)
    return quote(
        private func $(fucnNameIdent)(): String {
            return $userDefinedName
        }
    )
}

// class ClassMethodDeclVisitor <: Visitor {.
//     private let varMapName = "_varMapReserved"

//     private func checkVarMapping(decl: NodeFormat_VarDecl): Bool {
//         return decl.getIdentifier().value == this.varMapName
//     }

//     override public func visitDecl(decl: Decl): Bool {
//         if (decl.isFuncDecl()) {
//             //stop processing func so it won't include var declaration inside funcs
//             return false
//         }

//         if (decl.isVarDecl()) {
//             if (checkVarMapping(decl)) {
//                 //stop walking vars when there is already a mapping declared
//                 return false
//             }
//         }
        
//         return true
//     }
// }