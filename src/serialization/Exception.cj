macro package serialization

class AdaptorMissingException <: Exception {
    public init(message: String) {
        super(message)
    }
}

class TypeInferrenceException <: Exception {
    public init(message: String) {
        super(message)
    }
}

class MacroExpansionException <: Exception {
    public init(message: String) {
        super(message)
    }
}
