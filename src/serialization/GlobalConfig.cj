macro package serialization

from std import collection.*

class GlobalConfig {
    public let adaptorFactry = JsonAdaptorFactory()
    
    public let userDefinedVarMap : HashMap<String, String> = HashMap()
    public let ignoredVarSet: HashSet<String> = HashSet()
    
    public init() {
        registerDefaultMap()
    }

    private func registerDefaultMap() {
        //TODO: get type string with compile time dynamic, so that i will not break when type name changes 
        adaptorFactry.registrer("String", StringAdaptor())
        adaptorFactry.registrer("Bool", BoolAdaptor())
        adaptorFactry.registrer("Int64", IntAdaptor())
        adaptorFactry.registrer("Float64", FloatAdaptor())
    }

    public func reset() {
        this.userDefinedVarMap.clear()
        this.ignoredVarSet.clear()
    }
}