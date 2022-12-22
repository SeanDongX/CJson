package serialization.adaptor

public class HashSetAdaptor <: JsonCollectionAdaptorImpl {
    public init(defalutValueExprStore: DefaultValueExprStore, adaptorFactory: JsonAdaptorFactory) {
        super(defalutValueExprStore, adaptorFactory)
    }
    
    protected func insertValueExpr(valueReceiver_Tk: Tokens, genericVar_Tk: Tokens): Tokens {
        return quote(
            $valueReceiver_Tk.put($genericVar_Tk)
        )
    }
}