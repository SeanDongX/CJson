package serialization

/*
* Verifier for tokens
*/
public class TokenVerifier {
    /*
    * Verifies class decl token
    * @param input_Tk the token to verify
    * @marcoName the marco name to check against
    * @return NodeFormat_ClassDecl the input token as NodeFormat_ClassDecl type
    */
    public static func verifyClassDecl(input_Tk: Tokens, marcoName: String): (Option<NodeFormat_ClassDecl>, Option<NodeFormat_StructDecl>) {
        var decl = parseDecl(input_Tk)

        if (decl.isClassDecl()) {
            return (Some(decl.asClassDecl()), None)
        } else if (decl.isStructDecl()) {
            return (None, Some(decl.asStructDecl()))
        } else {
            throw TokenVerificationException("${marcoName} is only allowed for class or struct")
        }

        
    }

    /*
    * Verifies var decl token
    * @param input_Tk the token to verify
    * @marcoName the marco name to check against
    * @return NodeFormat_ClassDecl the input token as NodeFormat_VarDecl type
    */
    public static func verifyVarDecl(input_Tk: Tokens, marcoName: String): NodeFormat_VarDecl {
        var decl = parseDecl(input_Tk)

        if (!decl.isVarDecl()) {
            throw TokenVerificationException("${marcoName} is noly allow for class level vars")
        }

        return decl.asVarDecl()
    }
}
  