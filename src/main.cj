package default

from encoding import json.*
from std import collection.*
from std import io.*

import  myMacro.*

main(): Unit {
    var myClass = MyClass()
    var jsonValues = JsonParser().parse("{\"v1\": \"String1\",\"v2\": \"String2\", \"v3\": \"10\"}").asObject().getOrThrow()
    myClass.v1 = jsonValues.get("v1").asString().getOrThrow().getValue()
    myClass.v2 = jsonValues.get("v2").asString().getOrThrow().getValue() 
    
}

interface MyInterface {
    func rotate(): Unit
}

open class BaseClass {
    public func sayHello() {
        println("hello")
    }
}

@classMarco
class MyClass <: BaseClass & MyInterface {
    public var v1: String = "Value1"
    public var v2: String = "Value2"
    //public var v3: Int64 = 10

    public init() {
        this.v2 = "V2+"
    }

    public func rotate() {
        var v: String = this.v2
        this.v2 = this.v1
        this.v1 = v
    }

    @funcMarco
    public func myFunc() {
        println("myFunc")
    }
}