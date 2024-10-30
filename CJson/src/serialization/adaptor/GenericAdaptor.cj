package CJson.serialization.adaptor

internal import CJson.serialization.common.*

/*
* Core implementation of JsonAdaptor for generic
*/
public abstract class GenericAdaptor <: Adaptor & JsonAdaptor {
    protected var adaptorFactory: JsonAdaptorFactory
    
    public init(defalutValueExprStore: DefaultValueExprStore, adaptorFactory: JsonAdaptorFactory) {
        super(defalutValueExprStore)
        this.adaptorFactory = adaptorFactory
    }

    protected func getContainerIdentifier(): String {
        return thisType.getOrThrow().getTypeName()
    }

    protected func getGenericType(): TypeNode {
        return (thisType.getOrThrow() as RefType).getOrThrow().typeArguments[0]
    }
    
    protected func getGenericTypeName(): String {
        return getGenericType().getTypeName()
    }

    public func getGenericTypeAdaptor(): JsonAdaptor {
        return adaptorFactory.getAdaptor(getGenericTypeName())
    }


}