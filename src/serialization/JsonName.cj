macro package serialization

from std import ast.*
from encoding import json.*

public macro JsonName(attr_Tk: Tokens, input_Tk: Tokens): Tokens {
    var decl = verifyVarDecl(input_Tk, "JsonAttribute")
    
    globalConfig.userDefinedVarMap.put(decl.getIdentifier().value, checkVarNameAttr(attr_Tk))
    
    return input_Tk
}

func checkVarNameAttr(attr_Tk: Tokens): String {
    var token = attr_Tk[0]
    if (token.kind == STRING_LITERAL) {
        return token.value
    } else {
        throw Exception("JsonAttribute requies a string parameter at position 0, find ${token.kind} instead") 
    }
    
}