package test

from std import time.Time

import serialization.adaptor.*

@JsonSerializable
class ClassWithTime {   
    public var intVar: Int64 = 10
    public var time: Time = Time.now()
}

@Test
class TestCustomAdaptor {
    private let JSON_WITH_TIME = "{\"intVar\":20,\"time\":\"2022-12-21T03:21:51+08:00\"}"

    @TestCase
    func testToJson(): Unit {

        @Assert(ClassWithTime.fromJson(JSON_WITH_TIME).toJson(), JSON_WITH_TIME)
    }
}