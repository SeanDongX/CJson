from std import unittest.*
from std import unittest.testmacro.*

from encoding import json.*
from std import collection.*
from std import io.*

import serialization.*

let MYCLASS_JSON = "{\"stringVar1\": \"String1\",\"stringVar2_alias\": \"String2\", \"intVar\": 10, \"boolVar\": true, \"floatVar\": 38.09}"
let MYCLASS_JSON_WITH_IGNORE = "{\"stringVar1\": \"String1\",\"stringVar2_alias\": \"String2\", \"intVar\": 10, \"boolVar\": true, \"floatVar\": 38.09, \"ignored\": \"IgnoredValue\"}"
let MYNEWCLASS_JSON = "{\"stringVar1\": \"S1\",\"stringVar2_alias2\": \"S2\", \"v4\": 10}"
let NESTEDJSON = "{\"p1\": \"v1\",\"nested\": {\"c1\": 10}}"

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

@Test
public class TestSerialization {
    
    @TestCase
    func testFromJson(): Unit {
        var myClass = MyClass()
        var jsonValues = JsonParser().parse(MYCLASS_JSON).asObject().getOrThrow()
        myClass.stringVar1 = jsonValues.get("stringVar1").asString().getOrThrow().getValue()
        myClass.stringVar2 = jsonValues.get("stringVar2_alias").asString().getOrThrow().getValue() 
        myClass.intVar = jsonValues.get("intVar").asInt().getOrThrow().getValue()
        myClass.boolVar = jsonValues.get("boolVar").asBool().getOrThrow().getValue()
        myClass.floatVar = jsonValues.get("floatVar").asFloat().getOrThrow().getValue()

        var myClass1 = MyClass.fromJson(MYCLASS_JSON)
        @Assert(myClass.stringVar1, myClass1.stringVar1)
        @Assert(myClass.stringVar2, myClass1.stringVar2)
        @Assert(myClass.intVar, myClass1.intVar)
        @Assert(myClass.boolVar, myClass1.boolVar)
        @Assert(myClass.floatVar, myClass1.floatVar)
    }

    @TestCase
    func testToJson(): Unit {
        var myClass = MyClass()
        myClass.stringVar1 = "String1"
        myClass.stringVar2 = "String2"
        myClass.intVar = 10
        myClass.boolVar = true
        myClass.floatVar = 38.09

        var map: HashMap<String, JsonValue> = HashMap()
        map.put("stringVar1", JsonString(myClass.stringVar1))
        map.put("stringVar2_alias", JsonString(myClass.stringVar2))
        map.put("intVar", JsonInt(myClass.intVar))
        map.put("boolVar", JsonBool(myClass.boolVar))
        map.put("floatVar", JsonFloat(myClass.floatVar))

        @Assert(JsonObject(map).toString(), myClass.toJson())
    }

    @TestCase
    func testIgnore(): Unit {
        var myClass = MyClass()
        myClass.stringVar1 = "String1"
        myClass.stringVar2 = "String2"
        myClass.intVar = 10
        myClass.ignored = "SomeValue"
        
        @Assert(!myClass.toJson().contains("ignored"), true)
        @Assert(MyClass.fromJson(MYCLASS_JSON).ignored, "OriginalValue")
        @Assert(MyClass.fromJson(MYCLASS_JSON_WITH_IGNORE).ignored, "OriginalValue")

    }

    @TestCase
    func testFromJsonForTwo(): Unit {
        var myClass = MyClass()
        var jsonValues = JsonParser().parse(MYCLASS_JSON).asObject().getOrThrow()
        myClass.stringVar1 = jsonValues.get("stringVar1").asString().getOrThrow().getValue()
        myClass.stringVar2 = jsonValues.get("stringVar2_alias").asString().getOrThrow().getValue() 
        myClass.intVar = jsonValues.get("intVar").asInt().getOrThrow().getValue()

        var myClass1 = MyClass.fromJson(MYCLASS_JSON)
        println(myClass.stringVar1 == myClass1.stringVar1 && myClass.stringVar2 == myClass1.stringVar2 && myClass.intVar == myClass1.intVar)

        var myNewClass = MyNewClass()
        var jsonValues2 = JsonParser().parse(MYNEWCLASS_JSON).asObject().getOrThrow()
        myNewClass.stringVar1 = jsonValues2.get("stringVar1").asString().getOrThrow().getValue()
        myNewClass.stringVar2 = jsonValues2.get("stringVar2_alias2").asString().getOrThrow().getValue() 
        myNewClass.v4 = jsonValues2.get("v4").asInt().getOrThrow().getValue()

        var myNewClass2 = MyNewClass.fromJson(MYNEWCLASS_JSON)
        @Assert(myNewClass.stringVar1, myNewClass2.stringVar1)
        @Assert(myNewClass.stringVar2, myNewClass2.stringVar2)
        @Assert(myNewClass.v4, myNewClass2.v4)
    }

    @TestCase
    func testNestedFromJson(): Unit {
        var parent = NestedParent()
        var jsonValues = JsonParser().parse(NESTEDJSON).asObject().getOrThrow()
        parent.p1 = jsonValues.get("p1").asString().getOrThrow().getValue()
        
        parent.nested = NestedChild()
        var nestedJson = jsonValues.get("nested").asObject().getOrThrow()
        parent.nested.c1 =nestedJson.get("c1").asInt().getOrThrow().getValue()
        
        var parent1 = NestedParent.fromJson(NESTEDJSON)
        @Assert(parent.p1, parent1.p1)
        @Assert(parent.nested.c1, parent1.nested.c1)
    }

}

main(): Unit {
    let test = TestSerialization()
    test.execute()
    test.printResult()
}
