## 介绍

Json 序列化/反序列化工具，自动给被标记的类增加fromJson()和toJson()等方法，使其自身具备序列化/反序列化能力

### 特性

- 🚀 只需使用@JsonSerializable宏标记类名，几个使其具备序列化/反序列化能力

- 🛠️ 支持使用@JsonName(xxxx)标记类成员，定制序列化属性名为xxx

- 🎁 支持使用@JsonIgnore标记类成员，使其被序列化过程忽略

- ⛳ 支持使用默认值，克服json中的缺失值

### 接口说明
- 使用@JsonSerializable标记被序列化/反序列化对象
- 使用@JsonName["alias"]定制属性的序列化键值
- 使用JsonIgnore标记需要被忽略的属性

详见 /src/test目录下的测试用例

```
@JsonSerializable
class ClassWithCollction {
    public var p1: String = "v1"
    public var p2: Int64 = 1
    public var array: ArrayList<String> =  ArrayList<String>()
}

@Test
class TestCollection {
    private let JSON_WITH_COLLECTION = "{\"p1\":\"v1\",\"p2\":299,\"array\":[\"8\",\"7\"]}"

    @TestCase
    func testToJson(): Unit {        
        @Assert(ClassWithCollction.fromJson(JSON_WITH_COLLECTION).toJson(), JSON_WITH_COLLECTION)
    }
}

```

### 编译执行

编译：
```shell
cpm build
```

单元测试：
```shell
cpm test
```
