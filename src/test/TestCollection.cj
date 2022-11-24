package test

from std import unittest.*
from std import unittest.testmacro.*

from encoding import json.*
from std import collection.*
from std import io.*

import jsonmacro.*

@JsonSerializable
class ClassWithCollction {
    public var p1: String = "v1"
    public var p2: Int64 = 1
    public var array: ArrayList<String> =  ArrayList<String>()
    public var set: HashSet<String> = HashSet<String>()
    //TODO: fix error when using HashSet<Int64> Array<Bool> Array<Float>
}

@Test
class TestCollection {
    private let JSON_WITH_COLLECTION = "{\"p1\":\"v1\",\"p2\":299,\"array\":[\"8\",\"7\"],\"set\":[\"s1\",\"s2\"]}"

    @TestCase
    func testToJson(): Unit {        
        @Assert(ClassWithCollction.fromJson(JSON_WITH_COLLECTION).toJson(), JSON_WITH_COLLECTION)
    }
}