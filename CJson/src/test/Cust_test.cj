package CJson.test

import std.convert.*
import std.time.DateTime
 
import CJson.jsonmacro.*
import CJson.serialization.*

class CustInt64Serializer <: CustJsonSerializable<Int64> {
    public static func fromJson(json: String): Int64 {
        var value = Int64.tryParse(json) ?? 0
        return value * 100
    }

    public static func toJsonValue(value: Int64): JsonValue {
        return JsonInt(value/100)
    }
}

class CustDateTimeSerializer <: CustJsonSerializable<DateTime> {
    public static func fromJson(json: String): DateTime {
        let value = DateTime.parse(json.trimLeft("\"").trimRight("\""))
        return value.addYears(-1)
    }

    public static func toJsonValue(value: DateTime): JsonValue {
        return  JsonString(value.addYears(1).toString())
    }
}

@JsonSerializable
public class CustTest {
    @JsonCust[CustInt64Serializer]
    var count: Int64 = 99

    @JsonCust[CustDateTimeSerializer]
    var time: DateTime = DateTime.now()
}

@Test
public class TestCUst {
    private let CUSTTEST_JSON = "{\"count\":88,\"time\":\"2023-12-25T00:00:00+01:00\"}"
    @TestCase
    func testCustFromJson(): Unit {
        let cust = CustTest.fromJson(CUSTTEST_JSON)
        @Assert(cust.count, 8800)
        @Assert(cust.time.year, 2022)
    }

    @TestCase
    func testCustToJson(): Unit {
        @Assert(CustTest.fromJson(CUSTTEST_JSON).toJson(), CUSTTEST_JSON)
    }
}