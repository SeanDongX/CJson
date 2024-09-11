package CJson.serialization.adaptor

public interface DefaultValueExprStore {
    func hasValueExpr(varIdentifierName: String): Bool
    func getValueExpr(varIdentifierName: String): Expr
}
