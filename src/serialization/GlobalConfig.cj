macro package serialization

from std import collection.*

class GlobalConfig {
    public let userDefinedVarMap : HashMap<String, String> = HashMap()
    public let ignoredVarSet: HashSet<String> = HashSet()

    public func reset() {
        this.userDefinedVarMap.clear()
        this.ignoredVarSet.clear()
    }
}