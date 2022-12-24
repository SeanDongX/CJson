package cjsonExample

//1. the following package must be imported, when Custom serializer is needed
from CJson import serialization.IJsonSerializable

@JsonSerializable
public class ExampleTwo {
    public var name:String = "New Year"
    public var time:CustomTime = CustomTime(Time.now())
}

public class CustomTime {
    public CustomTime(let value: Time){
    }
}

//2. extend and implement IJsonSerializable<T> for custom serializer of type T
extend CustomTime <: IJsonSerializable<CustomTime> {
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