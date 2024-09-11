package CJson.serialization

import CJson.serialization.adaptor.*
/*
* The global configuration
*/
public class GlobalConfig <: DefaultValueExprStore {
    public let adaptorFactry = JsonAdaptorFactory()
    
    public let userDefinedVarMap : HashMap<String, String> = HashMap()
    public let ignoredVarSet: HashSet<String> = HashSet()
    public var defaultValueMap: Map<String, Expr> = HashMap()
    
    public init() {
        registerDefaultMap()
    }

    private func registerDefaultMap() {
        //TODO: get type string with compile time dynamic, so that i will not break when type name changes 
        adaptorFactry.registrer("String", StringAdaptor(this))
        adaptorFactry.registrer("Bool", BoolAdaptor(this))
        adaptorFactry.registrer("Int64", IntAdaptor(this))
        adaptorFactry.registrer("Float64", FloatAdaptor(this))
        adaptorFactry.registrer("DateTime", TimeAdaptor(this))
        adaptorFactry.registrer("ArrayList", ArrayListAdaptor(this, adaptorFactry))
        adaptorFactry.registrer("HashSet", HashSetAdaptor(this, adaptorFactry))
    }

    /*
    * Resets the configs for the next class instance, including usr defined var name mapping and ignored vars
    */
    public func reset() {
        this.userDefinedVarMap.clear()
        this.ignoredVarSet.clear()
    }

    public func hasValueExpr(varIdentifierName: String) {
        return defaultValueMap.contains(varIdentifierName)
    }

    public func getValueExpr(varIdentifierName: String) {
        return defaultValueMap.get(varIdentifierName).getOrThrow()
    }
}