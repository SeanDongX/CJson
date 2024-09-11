package cjsonExample

//1. the following package must be imported, when Custom serializer is needed
import CJson.serialization.IJsonSerializable
import CJson.jsonmacro.*

@JsonSerializable
public class ExampleTwo {
    public var name:String = "New Year"
    public var time:CustomTime = CustomTime(DateTime.now())
}

public class CustomTime {
    public CustomTime(let value: DateTime){
    }
}

//2. extend and implement IJsonSerializable<T> for custom serializer of type T
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