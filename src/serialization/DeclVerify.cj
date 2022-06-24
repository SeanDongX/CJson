macro package serialization

from std import ast.*

/*
* Verifier for tokens
*/
class TokenVerifier {
    /*
    * Verifies class decl token
    * @param input_Tk the token to verify
    * @marcoName the marco name to check against
    * @return NodeFormat_ClassDecl the input token as NodeFormat_ClassDecl type
    */
    static func verifyClassDecl(input_Tk: Tokens, marcoName: String): NodeFormat_ClassDecl {
        var decl = ParseDecl(input_Tk)

        if (!decl.isClassDecl()) {
            throw Exception("${marcoName} is noly allow for class")
        }

        return decl.asClassDecl()
    }


    /*
    * Verifies var decl token
    * @param input_Tk the token to verify
    * @marcoName the marco name to check against
    * @return NodeFormat_ClassDecl the input token as NodeFormat_VarDecl type
    */
    static func verifyVarDecl(input_Tk: Tokens, marcoName: String): NodeFormat_VarDecl {
        var decl = ParseDecl(input_Tk)

        if (!decl.isVarDecl()) {
            throw Exception("${marcoName} is noly allow for class level vars")
        }

        return decl.asVarDecl()
    }
}
  