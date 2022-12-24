package serialization.adaptor

public open class Adaptor {
    protected var thisType: Option<NodeFormat_Type> = None
    protected var defalutValueExprStore: DefaultValueExprStore

    public init(defalutValueExprStore: DefaultValueExprStore) {
        this.defalutValueExprStore = defalutValueExprStore
    }

    
    public func setType(thisType: NodeFormat_Type) {
       this.thisType = thisType
    }

    public func getType(): NodeFormat_Type {
        return thisType.getOrThrow()
    }

    /*
    * The core operation for interface fromJsonValue func
    * @param valueReceiver_TK the receiver for the deserialized value
    * @param varIdentifierName the identifier name of the receiver, using for internal namespaing
    * @param valueParse_Tk the token repsenetation for value parsing operations
    * @return Tokens the token representation 
    */
    protected func fromJsonValueCore(valueReceiver_TK: Tokens, varIdentifierName: String, valueParse_Tk: Tokens, defaultValueAssign_Tk: Tokens): Tokens {
        var internalDefaultValueAssign_Tk = defaultValueAssign_Tk
        var hasDefaultValue = quote(false)

        if (defalutValueExprStore.hasValueExpr(varIdentifierName)) {
            hasDefaultValue = quote(true)
            internalDefaultValueAssign_Tk = quote(
                $valueReceiver_TK = $(defalutValueExprStore.getValueExpr(varIdentifierName))
            )
        }

        return quote(
            $internalDefaultValueAssign_Tk
            try {
                $valueParse_Tk
            } catch(exp: Exception) {
                if (! $hasDefaultValue) {
                    throw exp
                }
            }
        )
    }
    
}
