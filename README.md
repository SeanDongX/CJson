## 介绍

Json 序列化/反序列化工具，自动给被标记的类增加fromJson()和toJson()等方法，使其自身具备序列化/反序列化能力

### 特性

- 🚀 只需使用@JsonSerializable宏标记类名，几个使其具备序列化/反序列化能力

- 🛠️ 支持使用@JsonName(xxxx)标记类成员，定制序列化属性名为xxx

- 🎁 支持使用@JsonIgnore标记类成员，使其被序列化过程忽略

- ⛳ 支持使用默认值，克服json中的缺失值

### 接口说明


### 编译执行

编译：
```shell
cpm build
```

单元测试：
```shell
cpm test
```