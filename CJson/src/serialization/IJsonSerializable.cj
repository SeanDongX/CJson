package CJson.serialization

internal import encoding.json.JsonObject

public interface IJsonSerializable<T> {
    static func fromJson(json: String) : T
    func toJsonObject(): JsonObject
    func toJson(): String 
}