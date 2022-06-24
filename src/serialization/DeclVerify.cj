macro package serialization

from std import ast.*

func verifyClassDecl(input_Tk: Tokens, marcoName: String): NodeFormat_ClassDecl {
    var decl = ParseDecl(input_Tk)

    if (!decl.isClassDecl()) {
        throw Exception("${marcoName} is noly allow for class")
    }

    return decl.asClassDecl()
}


func verifyVarDecl(input_Tk: Tokens, marcoName: String): NodeFormat_VarDecl {
    var decl = ParseDecl(input_Tk)

    if (!decl.isVarDecl()) {
        throw Exception("${marcoName} is noly allow for class level vars")
    }

    return decl.asVarDecl()
}
  