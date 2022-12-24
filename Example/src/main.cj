package cjsonExample

main() {
    println(ExampleOne.fromJson("{\"name\":\"Chrsitmas\",\"time\":\"2022-12-25T00:00:00+01:00\"}").toJson())
    println(ExampleTwo.fromJson("{\"name\":\"New Year\",\"time\":{\"value\":\"CUST_2023-01-01T00:00:00+08:00\"}}").toJson())
}