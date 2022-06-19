package default

from encoding import json.*
from std import collection.*


interface MyInterface {
    func rotate(): Unit
}

open class BaseClass {
    public func sayHello() {
        println("hello")
    }
}

@JsonSerializable
class MyClass <: BaseClass & MyInterface {   
    public var stringVar1: String = "Value1"
    
    @JsonName["stringVar2_alias"]
    public var stringVar2: String = "Value2"
    
    public var intVar: Int64 = 10
    public var boolVar: Bool = false
    public var floatVar: Float64 = 99.01

    //public var array: Array<String> = Array()
    //public var set: HashSet<String> = HashSet()


    @JsonIgnore
    public var ignored: String = "OriginalValue"

    public init() {
        this.stringVar2 = "stringVar2+"
    }

    public func rotate() {
        var v: String = this.stringVar2
        this.stringVar2 = this.stringVar1
        this.stringVar1 = v
    }
}

@JsonSerializable
class MyNewClass <: BaseClass & MyInterface {   
    public var stringVar1: String = "S1C"
    
    @JsonName["stringVar2_alias2"]
    public var stringVar2: String = "S2C"
    
    public var v4: Int64 = 10

    public init() {

    }

    public func rotate() {
        var v: String = this.stringVar2
        this.stringVar2 = this.stringVar1
        this.stringVar1 = v
    }
}

@JsonSerializable
class NestedChild {
    public var c1: Int64 = 1
}

@JsonSerializable
class NestedParent {
    public var p1: String = "v1"
    public var nested: NestedChild = NestedChild()
}