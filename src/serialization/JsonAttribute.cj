macro package serialization

from std import ast.*
from encoding import json.*

public macro JsonAttribute(attr: Tokens, input: Tokens): Tokens {
    if (!ParseDecl(input).isVarDecl()) {
        throw Exception("JsonAttribute is noly allow for class level vars")
    }
    
    userDefinedVarMap.put(ParseDecl(input).asVarDecl().getIdentifier().value, checkVarNameAttr(attr))
    
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