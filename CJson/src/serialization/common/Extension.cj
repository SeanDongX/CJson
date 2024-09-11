package CJson.serialization.common

import std.ast.*

public interface TokenExtesion {

}

extend TypeNode <: TokenExtesion {

    /*
    * Gets the type name
    *
    * @return String the name of the type
    */
    public func getTypeName(): String {
        try {
            if (this is RefType) {
                return (this as RefType).getOrThrow().identifier.value
            } else {
                return (this as PrimitiveType).getOrThrow().keyword.value
            }            
        } catch (exp: NoneValueException) {
            throw Exception("Error when try to get type name")
        }
    }
}

extend VarDecl <: TokenExtesion {

    /*
     * Get info from VarDecl
     *
     * @return (Token, String, String) the identifier, name, type name of the var
     */
    public func getVarInfo(): (Token, String, String) {
        let identifier = identifier
        let name = identifier.value
        var typeName: String

        try {
            typeName = this.declType.getTypeName()
        } catch (exp: NoneValueException) {
            throw TypeInferrenceException("Field ${name} must be declared with a specific type instead of using a inferred type")
        }
        
        return (identifier, name, typeName)
    }
}