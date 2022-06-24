macro package serialization

from std import ast.*
from encoding import json.*

public macro JsonIgnore(input_Tk: Tokens): Tokens {
    var decl = verifyVarDecl(input_Tk, "JsonIgnore")
    
    globalConfig.ignoredVarSet.put(decl.getIdentifier().value)

    return input_Tk
}
