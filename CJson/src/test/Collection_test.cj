package CJson.test

import std.unittest.*
import std.unittest.testmacro.*

internal import encoding.json.*
internal import std.collection.*
internal import std.io.*

import CJson.jsonmacro.*
import CJson.serialization.IJsonSerializable

@JsonSerializable
class ClassWithCollction {
    public var p1: String = "v1"
    public var p2: Int64 = 1
    public var array: ArrayList<String> =  ArrayList<String>()
}

@Test
class TestCollection {
    private let JSON_WITH_COLLECTION = "{\"p1\":\"v1\",\"p2\":299,\"array\":[\"8\",\"7\"]}"

    @TestCase
    func testToJson(): Unit {        
        @Assert(ClassWithCollction.fromJson(JSON_WITH_COLLECTION).toJson(), JSON_WITH_COLLECTION)
    }
}

@JsonSerializable
class ClassWithMoreTypeOfCollctions {
    public var stringArray: ArrayList<String> =  ArrayList<String>()
    public var int64Set: HashSet<Int64> = HashSet<Int64>()
    public var boolArray: ArrayList<Bool> =  ArrayList<Bool>()
    public var float64Set: HashSet<Float64> = HashSet<Float64>()
}

@Test
class TestMoreTypeOfCollctions {
    private let JSON_WITH_COLLECTION = "{\"stringArray\":[\"8\",\"7\"],\"int64Set\":[88,109],\"boolArray\":[false,true,false],\"float64Set\":[88.8,-111.092]}"

    @TestCase
    func testToJson(): Unit {        
        @Assert(ClassWithMoreTypeOfCollctions.fromJson(JSON_WITH_COLLECTION).toJson(), JSON_WITH_COLLECTION)
    }
}