package default

from encoding import json.*
from std import collection.*
from std import io.*

import  myMacro.*

main(): Unit {
    var parser = JsonParser()

    var v = parser.parse("{\"f1\": \"String\"}")
    var map = HashMap<String, JsonValue>()
    map.put("a",  v)
    map.put("b",  JsonString("1"))

    var jObjct = JsonObject(map)
    println(jObjct.toJsonString())
}

@classMarco
class MyClass {
    public var v1: String = "Value1"

   
    private var v2: String = "Value2"
    public var v3: Int64 = 10

    public init() {
        this.v2 = "V2+"
    }

    @funcMarco
    public func rotate() {
        var v = this.v2
        this.v2 = this.v1
        this.v1 = v
    }
}