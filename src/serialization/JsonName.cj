macro package serialization

from std import ast.*
from encoding import json.*

public macro JsonName(attr: Tokens, input: Tokens): Tokens {
    var decl = verifyVarDecl(input, "JsonAttribute")
    
    globalConfig.userDefinedVarMap.put(decl.getIdentifier().value, checkVarNameAttr(attr))
    
    return input
}

func checkVarNameAttr(attr: Tokens): String {
    var token = attr[0]
    if (token.kind == STRING_LITERAL) {
        return token.value
    } else {
        throw Exception("JsonAttribute requies a string parameter at position 0, find ${token.kind} instead") 
    }
    
}