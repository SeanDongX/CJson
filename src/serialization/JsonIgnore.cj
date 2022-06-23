macro package serialization

from std import ast.*
from encoding import json.*

public macro JsonIgnore(input: Tokens): Tokens {
    var decl = verifyVarDecl(input, "JsonIgnore")
    
    globalConfig.ignoredVarSet.put(decl.getIdentifier().value)

    return input
}
