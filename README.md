## 介绍

Json 序列化/反序列化工具，自动给被标记的类增加fromJson()和toJson()等方法，使其自身具备序列化/反序列化能力

### 特性

- 🚀 只需使用@JsonSerializable宏标记类名，几个使其具备序列化/反序列化能力

- 🛠️ 支持使用@JsonName(xxxx)标记类成员，定制序列化属性名为xxx

- 🎁 支持使用@JsonIgnore标记类成员，使其被序列化过程忽略

- ⛳ 支持使用默认值，克服json中的缺失值

- 🛠️ 支持定制类的序列化和反序列化，通过直接实现或使用扩展实现IJsonSerializable<T>

### 接口说明
- 使用@JsonSerializable标记被序列化/反序列化对象
- 使用@JsonName["alias"]定制属性的序列化键值
- 使用JsonIgnore标记需要被忽略的属性


### 编译执行
编译：
```shell
cd CJson
cjpm build
```

单元测试：
```shell
cd CJson
cjpm test
```

运行demo：
```shell
cd Example
cjpm run
单元测试：
```

## 详见 Example/src的样例和CJson/src/test目录下的测试用例

```swift
package cjsonExample

internal import std.time.DateTime

//1. the following three packages must be imported by decoraetd class/struct, or by it's belonging package
internal import std.collection.HashMap
internal import encoding.json.*
import CJson.jsonmacro.*
import CJson.serialization.IJsonSerializable

//2. use @JsonSerializable to decorate target class
@JsonSerializable
public class ExampleOne {
    //3. class properties must be declared with explicit type
    var name: String = "Chrsitmas"
    var time: DateTime = DateTime.now()
}

@JsonSerializable
public class ExampleOne_Init {
    var name: String
    var time: DateTime

    //4. the target class must have a parameter-less contructor
    //try comment out this init method to see compile errors
    //ExampleOne class will work since there it has an equavalent "hidden" parameter-less contructor
    public init() {
        this.name = "Chrsitmas_init"
        this.time = DateTime.parse("2022-12-25T00:00:00+01:00")
    }

    public init(name: String) {
        this.name = name
        this.time = DateTime.parse("2022-12-25T00:00:00+01:00")
    }
}


//struct is also supported
@JsonSerializable
public struct ExampleOneStruct {
    var name: String = "Labor Day"
    var time: DateTime

    public init () {
        this.time = DateTime.now()
    }
}
```
