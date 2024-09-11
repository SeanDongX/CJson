package CJson.test

import std.ast.*

import CJson.serialization.IJsonSerializable
import CJson.jsonmacro.*
import std.time.DateTime

struct CustomTime {
    public CustomTime(let value: DateTime){
    }
}

extend CustomTime <: IJsonSerializable<CustomTime> {
    public static func fromJson(json: String) : CustomTime {
        var jsonObject = JsonValue.fromStr( json ).asObject() 
        return CustomTime(DateTime.parse(jsonObject.get("value").getOrThrow().asString().getValue()[5..]))
    }

    public func toJsonObject(): JsonObject {
        var map: HashMap < String , JsonValue >= HashMap()
        let s = "CUST_"
        map.put("value", JsonString(String.join(s, this.value.toString())))
        return JsonObject(map)
    }

    public func toJson(): String {
        return toJsonObject().toString()
    }
}

@JsonSerializable
class ClassWithCustomTimeAdaptor {
    public var intVar: Int64 = 10
    public var time: CustomTime = CustomTime(DateTime.now())
}

@Test
class TestCustomAdaptor {
    private let JSON_WITH_TIME = "{\"intVar\":10,\"time\":{\"value\":\"CUST_2022-12-21T03:21:51+08:00\"}}"

    @TestCase
    func testCustomTime(): Unit {
        @Assert(ClassWithCustomTimeAdaptor.fromJson(JSON_WITH_TIME).toJson(), JSON_WITH_TIME)
    }
}