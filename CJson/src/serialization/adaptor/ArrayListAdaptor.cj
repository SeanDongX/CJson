package CJson.serialization.adaptor

public class ArrayListAdaptor <: JsonCollectionAdaptorImpl {
    public init(defalutValueExprStore: DefaultValueExprStore, adaptorFactory: JsonAdaptorFactory) {
        super(defalutValueExprStore, adaptorFactory)
    }
    
    protected func insertValueExpr(valueReceiver_Tk: Tokens, genericVar_Tk: Tokens): Tokens {
        return quote(
            $valueReceiver_Tk.append($genericVar_Tk)
        )
    }
}
