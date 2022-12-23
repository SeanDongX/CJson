package test

from std import ast.*

struct CustomTime {
    public CustomTime(let value: Time){
    }
}

extend CustomTime {
    public static func fromJson(json: String) : CustomTime {
        var jsonObject = JsonValue.fromStr( json ).asObject() 
        return CustomTime(Time.parse(jsonObject.get("value").getOrThrow().asString().getValue().substring(5)))
    }

    public func toJsonObject(): JsonObject {
        var map: HashMap < String , JsonValue >= HashMap()
        let s = "CUST_"
        map.put("value", JsonString(s.concat(this.value.toString()))) 
        return JsonObject(map)
    }

    public func toJson(): String {
        return toJsonObject().toString()
    }
}

@JsonSerializable
class ClassWithCustomTimeAdaptor {
    public var intVar: Int64 = 10
    public var time: CustomTime = CustomTime(Time.now())
}

@Test
class TestCustomAdaptor {
    private let JSON_WITH_TIME = "{\"intVar\":10,\"time\":{\"value\":\"CUST_2022-12-21T03:21:51+08:00\"}}"

    @TestCase
    func testCustomTime(): Unit {
        @Assert(ClassWithCustomTimeAdaptor.fromJson(JSON_WITH_TIME).toJson(), JSON_WITH_TIME)
    }
}