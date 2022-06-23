macro package serialization

from std import ast.*

func verifyClassDecl(input: Tokens, marcoName: String): NodeFormat_ClassDecl {
    var decl = ParseDecl(input)

    if (!decl.isClassDecl()) {
        throw Exception("${marcoName} is noly allow for class")
    }

    return decl.asClassDecl()
}


func verifyVarDecl(input: Tokens, marcoName: String): NodeFormat_VarDecl {
    var decl = ParseDecl(input)

    if (!decl.isVarDecl()) {
        throw Exception("${marcoName} is noly allow for class level vars")
    }

    return decl.asVarDecl()
}
  