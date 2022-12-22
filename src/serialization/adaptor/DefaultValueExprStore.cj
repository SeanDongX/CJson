package serialization.adaptor

public interface DefaultValueExprStore {
    func hasValueExpr(varIdentifierName: String): Bool
    func getValueExpr(varIdentifierName: String): NodeFormat_Expr
}
