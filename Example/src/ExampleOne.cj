package cjsonExample

from std import time.Time

//1. the following three packages must be imported by decoraetd class/struct, or by it's belonging package
from std import collection.HashMap
from encoding import json.*
from CJson import jsonmacro.*

//2. use @JsonSerializable to decorate target class
@JsonSerializable
public class ExampleOne {
    //3. class properties must be declared with explicit type
    var name: String = "Chrsitmas"
    var time: Time = Time.now()
}

@JsonSerializable
public class ExampleOne_Init {
    var name: String
    var time: Time

    //4. the target class must have a parameter-less contructor
    //try comment out this init method to see compile errors
    //ExampleOne class will work since there it has an equavalent "hidden" parameter-less contructor
    public init() {
        this.name = "Chrsitmas_init"
        this.time = Time.parse("2022-12-25T00:00:00+01:00")
    }

    public init(name: String) {
        this.name = name
        this.time = Time.parse("2022-12-25T00:00:00+01:00")
    }
}


// //struct is also supported
// @JsonSerializable
// public struct ExampleOneStruct {
//     var name: String = "Labor Day"
//     var time: time

//     public init (time: Time) {
//         this.time = time
//     }
// }
