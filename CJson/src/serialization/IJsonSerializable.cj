package CJson.serialization

internal import encoding.json.{JsonObject, JsonValue}

public interface IJsonSerializable<T> {
    static func fromJson(json: String) : T
    func toJsonObject(): JsonObject
    func toJson(): String
}

public interface CustJsonSerializable<T> {
    static func fromJson(json: String) : T
    static func toJsonValue(obj: T) : JsonValue
}