macro package serialization

from std import collection.*

/*
* The global configuration
*/
class GlobalConfig {
    public let adaptorFactry = JsonAdaptorFactory()
    
    public let userDefinedVarMap : HashMap<String, String> = HashMap()
    public let ignoredVarSet: HashSet<String> = HashSet()
    public var defaultValueMap: Map<String, NodeFormat_Expr> = HashMap()
    
    public init() {
        registerDefaultMap()
    }

    private func registerDefaultMap() {
        //TODO: get type string with compile time dynamic, so that i will not break when type name changes 
        adaptorFactry.registrer("String", StringAdaptor())
        adaptorFactry.registrer("Bool", BoolAdaptor())
        adaptorFactry.registrer("Int64", IntAdaptor())
        adaptorFactry.registrer("Float64", FloatAdaptor())
        adaptorFactry.registrer("ArrayList", ArrayListAdaptor(adaptorFactry))
        adaptorFactry.registrer("HashSet", HashSetAdaptor(adaptorFactry))
    }

    /*
    * Resets the configs for the next class instance, including usr defined var name mapping and ignored vars
    */
    public func reset() {
        this.userDefinedVarMap.clear()
        this.ignoredVarSet.clear()
    }
}