package CJson.serialization.common

import std.ast.*
import std.collection.ArrayList

public interface TokenExtesion {

}

extend TypeNode <: TokenExtesion {

    /*
    * Gets the type name
    *
    * @return String the name of the type
    */
    public func getTypeName(): String {
        if (this is RefType) {
            return (this as RefType).getOrThrow().identifier.value
        } else if (this is PrimitiveType) {
            return (this as PrimitiveType).getOrThrow().keyword.value
        } else if (this is PrefixType) {
            throw TypeInferrenceException("Option type expressed as '?Type' is currently not supported, plese use 'Option<Type>' instead: ${this.toTokens()}")
        } else {
            throw TypeInferrenceException("Error when try to get type name for ${this.toTokens()}")
        }
    }
}

extend VarDecl <: TokenExtesion {

    /*
     * Get info from VarDecl
     *
     * @return (Token, String, String) the identifier, name, type name of the var
     */
    public func getVarInfo(): (Token, String, String, ArrayList<TypeNode>) {
        let identifier = identifier
        let name = identifier.value
        var typeName: String
        var typeArguments = ArrayList<TypeNode>()

        try {
            typeName = this.declType.getTypeName()
            if (this.declType is RefType) {
                let refType = (this.declType as RefType).getOrThrow()
                typeArguments = refType.typeArguments
            }
            
        } catch (exp: NoneValueException) {
            throw TypeInferrenceException("Field ${name} must be declared with a specific type instead of using a inferred type")
        }
        //TODO: return generic T if type is generic
        return (identifier, name, typeName, typeArguments)
    }
}