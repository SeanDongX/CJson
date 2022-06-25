package serialization

public class AdaptorMissingException <: Exception {
    public init(message: String) {
        super(message)
    }
}

public class TypeInferrenceException <: Exception {
    public init(message: String) {
        super(message)
    }
}

public class TokenVerificationException <: Exception {
    public init(message: String) {
        super(message)
    }
}

public class MacroExpansionException <: Exception {
    public init(message: String) {
        super(message)
    }
}

public class MacroParameterException <: Exception {
    public init(message: String) {
        super(message)
    }
}
