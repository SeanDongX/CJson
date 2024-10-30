package CJson.serialization.adaptor

internal import CJson.serialization.common.*

/*
* JsonAdaptor for Option type
*/
public class OptionAdaptor <: GenericAdaptor {
    public init(defalutValueExprStore: DefaultValueExprStore, adaptorFactory: JsonAdaptorFactory) {
        super(defalutValueExprStore, adaptorFactory)
    }

    private func getGenericAdatpor() {
        var genericType_Tk = getGenericType()
        var genericAdaptor = adaptorFactory.getAdaptor(getGenericTypeName())
        genericAdaptor.setType(genericType_Tk)
        return genericAdaptor
    }

    public func fromJsonValue(valueReceiver_Tk: Tokens, jsonVar_Tk: Tokens, varIdentifierName: String): Tokens {
        var genericType_Tk = getGenericType()
        var fromJsonExpr_Tk =  getGenericAdatpor().fromJsonValue(valueReceiver_Tk, jsonVar_Tk, varIdentifierName)

        return quote(
            if ($jsonVar_Tk is JsonNull) {
                $valueReceiver_Tk = Option<$genericType_Tk>.None
            } else {
                $fromJsonExpr_Tk
            }
        )
    }

    public func toJsonValueFunc(valueVar_Tk: Tokens, funcName_Tk: Tokens, varIdentifierName: String): Tokens {
        var innerFuncName_Tk = Tokens([Token(TokenKind.IDENTIFIER, funcName_Tk.toString() + "_inner")])
        var valueVar_getOrThrow_Tk = Tokens([Token(TokenKind.IDENTIFIER, valueVar_Tk.toString() + ".getOrThrow()")])

        var toJsonValueFuncExpr_Tk =  getGenericAdatpor().toJsonValueFunc(valueVar_getOrThrow_Tk, innerFuncName_Tk, varIdentifierName)

        return quote(
            $toJsonValueFuncExpr_Tk

            func $funcName_Tk() {
                return match($valueVar_Tk) {
                    case None => JsonNull()
                    case _ => $innerFuncName_Tk()
                }
            }
        )
    }
}