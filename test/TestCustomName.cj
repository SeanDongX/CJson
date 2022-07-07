from std import unittest.*
from std import unittest.testmacro.*

from encoding import json.*
from std import collection.*
from std import io.*

import jsonmacro.*

@JsonSerializable
class ClassWithCustomName {   
    public var stringVar1: String = "Value1"
    
    @JsonName["stringVar2_alias"]
    public var stringVar2: String = "Value2"
    
    public var intVar: Int64 = 10
}

@Test
public class TestCustomName {
    private let MYCLASS_JSON = "{\"stringVar1\": \"String1\",\"stringVar2_alias\": \"String2\", \"intVar\": 10}"

    @TestCase
    func testFromJson(): Unit {
        var myClass = ClassWithCustomName()
        var jsonValues = JsonParser().parse(MYCLASS_JSON).asObject().getOrThrow()
        myClass.stringVar1 = jsonValues.get("stringVar1").asString().getOrThrow().getValue()
        myClass.stringVar2 = jsonValues.get("stringVar2_alias").asString().getOrThrow().getValue() 
        myClass.intVar = jsonValues.get("intVar").asInt().getOrThrow().getValue()
        
        var myClass1 = ClassWithCustomName.fromJson(MYCLASS_JSON)
        @Assert(myClass.stringVar1, myClass1.stringVar1)
        @Assert(myClass.stringVar2, myClass1.stringVar2)
        @Assert(myClass.intVar, myClass1.intVar)        
    }

    @TestCase
    func testToJson(): Unit {
        var myClass = ClassWithCustomName()
        myClass.stringVar1 = "String1"
        myClass.stringVar2 = "String2"
        myClass.intVar = 10

        var map: HashMap<String, JsonValue> = HashMap()
        map.put("stringVar1", JsonString(myClass.stringVar1))
        map.put("stringVar2_alias", JsonString(myClass.stringVar2))
        map.put("intVar", JsonInt(myClass.intVar))

        @Assert(JsonObject(map).toString(), myClass.toJson())
    }
}