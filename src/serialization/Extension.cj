macro package serialization

extend NodeFormat_Type {
    public func getTypeName(): String {
        try {

            if (this.isRefType()) {
                return this.asRefType().getIdentifier().value
            } else {
                return this.asPrimitiveType().getPrimitive().value
            }            
        } catch (exp: NoneValueException) {
            throw Exception("Error when try to get type name")
        }
    }
}

extend NodeFormat_VarDecl {
    /**
     * Get info from VarDecl
     *
     * @return (Token, String, String) the identifier, name, type name of the var
     */
    public func getVarInfo(): (Token, String, String) {
        let identifier = this.getIdentifier()
        let name = identifier.value
        var typeName: String

        try {
            typeName = this.getType().getOrThrow().getTypeName()
        } catch (exp: NoneValueException) {
            throw TypeInferrenceException("Field ${name} must be declared with a specific type instead of using a inferred type")
        }
        
        return (identifier, name, typeName)
    }
}