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