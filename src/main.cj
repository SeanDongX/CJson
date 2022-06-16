package default

from encoding import json.*
from std import collection.*
from std import io.*

import  serialization.*

main(): Unit {
    testFromJson()
    testToJson()
}

func testFromJson(): Unit {
    var myClass = MyClass()
    var jsonValues = JsonParser().parse("{\"v1\": \"String1\",\"v2\": \"String2\", \"v3\": 10}").asObject().getOrThrow()
    myClass.v1 = jsonValues.get("v1").asString().getOrThrow().getValue()
    myClass.v2 = jsonValues.get("v2").asString().getOrThrow().getValue() 
    myClass.v3 = jsonValues.get("v3").asInt().getOrThrow().getValue()

    var myClass1 = MyClass.fromJson("{\"v1\": \"String1\",\"v2\": \"String2\", \"v3\": 10}")
    println(myClass.v1 == myClass1.v1 && myClass.v2 == myClass1.v2 && myClass.v3 == myClass1.v3)
}

func testToJson(): Unit {
    var myClass = MyClass()
    myClass.v1 = "String1"
    myClass.v2 = "String2"
    myClass.v3 = 10

    var map: HashMap<String, JsonValue> = HashMap()
    map.put("v1", JsonString(myClass.v1))
    map.put("v2", JsonString(myClass.v2))
    map.put("v3", JsonInt(myClass.v3))

    println(JsonObject(map).toString() == myClass.toJson())
}

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
    public var v1: String = "Value1"
    public var v2: String = "Value2"
    public var v3: Int64 = 10

    public init() {
        this.v2 = "V2+"
    }

    
    public func rotate() {
        var v: String = this.v2
        this.v2 = this.v1
        this.v1 = v
    }
}