package CJson.serialization.adaptor

public class BoolAdaptor <: Adaptor & JsonAdaptor {
    public init(defalutValueExprStore: DefaultValueExprStore) {
        super(defalutValueExprStore)
    }

    public func fromJsonValue(valueReceiver_Tk: Tokens, jsonVar_Tk: Tokens, varIdentifierName: String): Tokens {
        super.fromJsonValueCore(valueReceiver_Tk, varIdentifierName, 
            quote( $valueReceiver_Tk = $jsonVar_Tk.asBool().getValue() ),
            quote( $valueReceiver_Tk = false ))
    }
    
    public func toJsonValueFunc(valueVar_Tk: Tokens, funcName_Tk: Tokens, varIdentifierName: String): Tokens {
        return quote(
            func $funcName_Tk() {
                return JsonBool($valueVar_Tk)
            }
        )
    }
}
