package CJson.serialization.adaptor

public class TimeAdaptor <: Adaptor & JsonAdaptor {
    public init(defalutValueExprStore: DefaultValueExprStore) {
        super(defalutValueExprStore)
    }

    public func fromJsonValue(valueReceiver_Tk: Tokens, jsonVar_Tk: Tokens, varIdentifierName: String): Tokens {
        super.fromJsonValueCore(valueReceiver_Tk, varIdentifierName,
            quote( $valueReceiver_Tk = DateTime.parse($jsonVar_Tk.asString().getValue()) ),
            quote( $valueReceiver_Tk = DateTime.now() ))
    }
    
    public func toJsonValueFunc(valueVar_Tk: Tokens, funcName_Tk: Tokens, varIdentifierName: String): Tokens {
        return quote(
            func $funcName_Tk() {
                return JsonString($valueVar_Tk.toString())
            }
        )
    }
}
