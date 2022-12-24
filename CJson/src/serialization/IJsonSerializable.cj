package serialization

from encoding import json.JsonObject

public interface IJsonSerializable<T> {
    static func fromJson(json: String) : T
    func toJsonObject(): JsonObject
    func toJson(): String 
}