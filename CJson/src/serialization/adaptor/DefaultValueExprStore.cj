package CJson.serialization.adaptor

import std.ast.*

public interface DefaultValueExprStore {
    func hasValueExpr(varIdentifierName: String): Bool
    func getValueExpr(varIdentifierName: String): Expr
}
