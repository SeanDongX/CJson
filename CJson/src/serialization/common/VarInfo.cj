package CJson.serialization.common

import std.ast.{Token, TypeNode}
import std.collection.ArrayList

public class VarInfo {
    public VarInfo(public let identifier: Token,
                    public let name: String,
                    public let typeName: String,
                    public let typeArguments: ArrayList<TypeNode>) {
    }
}