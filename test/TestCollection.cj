from std import unittest.*
from std import unittest.testmacro.*

from encoding import json.*
from std import collection.*
from std import io.*

import serialization.*

let JSON_WITH_COLLECTION = "{\"p1\":\"v1\",\"array\":[\"c1\",\"c2\",\"c3\"]}"

@JsonSerializable
class ClassWithCollction {
    public var p1: String = "v1"
    public var array: ArrayList<String> = ArrayList()
}

@Test
class TestCollection {

    @TestCase
    func testFromJson(): Unit {
        var classWithCollection = ClassWithCollction()
        
        var jsonValues = JsonParser().parse(JSON_WITH_COLLECTION).asObject().getOrThrow()
        classWithCollection.p1 = jsonValues.get("p1").asString().getOrThrow().getValue()
        
        classWithCollection.array = ArrayList<String>()
        var jsonArray = jsonValues.get("array").asArray().getOrThrow()
        
        for (value in jsonArray.getItems()) {
            classWithCollection.array.add(value.asString().getOrThrow().getValue())
        }

        var classWithCollection1 = ClassWithCollction.fromJson(JSON_WITH_COLLECTION)
        @Assert(classWithCollection.p1, classWithCollection1.p1)
        @Assert(classWithCollection.array, classWithCollection1.array)
    }

    @TestCase
    func testToJson(): Unit {        
        @Assert(ClassWithCollction.fromJson(JSON_WITH_COLLECTION).toJson(), JSON_WITH_COLLECTION)
    }
}