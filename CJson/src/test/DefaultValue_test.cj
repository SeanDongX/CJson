package CJson.test

import CJson.serialization.IJsonSerializable
import CJson.jsonmacro.*

@JsonSerializable
class DefaultValueClass {
    public var p0: Int64 = 0
    public var p1: String = "v1"
    public var p2: Int64 = 99
    public var p3: Bool = false
    public var p4: Float64 = 10.990000
}

@Test
public class TestDefaultValue {
    private let DEFAULT_VALUE_JSON = "{\"p0\":0}"
    private let DEFAULT_TOJSON = "{\"p0\":0,\"p1\":\"v1\",\"p2\":99,\"p3\":false,\"p4\":10.99}"
    
    @TestCase
    func testFromJson(): Unit {
        @Assert(DefaultValueClass.fromJson(DEFAULT_VALUE_JSON).toJson(), DEFAULT_TOJSON)
    }
}