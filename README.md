# Logstash KS3 Output Plugin

This is a plugin for [Logstash](https://github.com/elastic/logstash).

It is fully free and fully open source. The license is Apache 2.0, meaning you are pretty much free to use it however you want in whatever way.

## 文档 Documentation

该插件可以累积上传 logstash events 到 KS3

首先，你需要拥有 KS3 的权限 (ak/sk) 和一个可写的bucket

上传到 KS3 前，该插件会将文件写到临时目录

_This plugin batches and uploads logstash events into Ksyun Object Storage Service (Ksyun KS3)._

_First, you should have a writable bucket and ks3 access permissions((Typically access_key_id and access_key_secret))._

_ks3 output plugin creates temporary files into the OS' temporary directory(You can set this configuration by **temporary_directory** option) before uploading them to ks3._


临时文件路径如下：

_ks3 output plugin output files have the following format_

```bash
/tmp/logstash/ks3/eaced620-e972-0136-2a14-02b7449ba0a9/logstash/1/ls.ks3.e27ff60b-98eb-42f8-87bb-09cdb56102c2.2021-08-03T20.16.part-0.data
```

|||
|---|---|
|/tmp/logstash/ks3| **temporary_directory** 选项指定的临时目录，默认为系统临时目录 |
|eaced620-e972-0136-2a14-02b7449ba0a9 | 随机 uuid |
|logstash/1|ks3 对象前缀|
|ls.ks3|标明是 logstash 插件|
|eaced620-e972-0136-2a14-02b7449ba0a9 | 随机 uuid |
|2018-12-24T14.27 | 创建时间 |
|part-0|分块|
|.data|后缀, `encoding` 是 gzip 的话，结尾为 .gz ，其他是 .data|

### 使用方法
样例:
```ruby
input {
  file {
    path => "/etc/logstash-7.3.0/sample.data"
    codec => json {
      charset => "UTF-8"
    }
  }
}

output {
  ks3 {
    endpoint => "ks3 endpoint"                            (required)
    bucket => "bucket"                                    (required)
    access_key_id => "ak"                                 (required)
    access_key_secret => "sk"                             (required)
    prefix => "logstash/ks3"                              (optional, default = "")
    recover => true                                       (optional, default = true)
    rotation_strategy => "size_and_time"                  (optional, default = "size_and_time")
    time_rotate => 15                                     (optional, default = 15) - Minutes
    size_rotate => 31457280                               (optional, default = 31457280) - Bytes
    encoding => "gzip"                                    (optional, default = "none")
    additional_ks3_settings => {                          (optional, default = 1024)
      secure_connection_enabled => false                  (optional, default = false)
      server_side_encryption_algorithm => "AES256"        (optional, default = "none")
    }
    codec => json {
      charset => "UTF-8"
    }
  }
}
```

### 插件配置文件选项

|Configuration|Type|Required|Comments|
|:---:|:---:|:---:|:---|
|endpoint|string|Yes|endpoint|
|bucket|string|Yes|bucket|
|access_key_id|string|Yes|ak|
|access_key_secret|string|Yes|sk|
|prefix|string|No|前缀|
|recover|string|No|插件支持崩溃恢复crash recovery, 可以设置 **recover** 为true，来从异常崩溃中恢复上传。|
|additional_ks3_settings|hash|No|附加的客户端配置: `server_side_encryption_algorithm`（服务端加密算法）, `secure_connection_enabled` （是否安全连接https/http）|
|temporary_directory|string|No|指定的临时目录，默认为系统临时目录|
|rotation_strategy|string|No|文件滚动更新策略。可选值：size、time、size_and_time（默认）|
|size_rotate|number|No|如果文件大小大于等于size_rotate，将滚动更新文件（依赖rotation_strategy）。默认为30 MBytes|
|time_rotate|number|No|如果文件的生存时长大于等于time_rotate，将滚动更新文件（依赖rotation_strategy）。默认为15分钟|
|upload_workers_count|number|No|上传线程并发数|
|upload_queue_size|number|No|上传队列大小|
|encoding|string|No|是否启用gzip压缩 `gzip` and `none`|

## 部署

```bash
./bin/logstash-plugin install /logstash-output-ks3/logstash-output-ks3-0.0.1-java.gem
```
结果如下：

```bash
Validating logstash-output-ks3
Installing logstash-output-ks3
Installation successful
```

查看插件 :
```bash
./bin/logstash-plugin list --verbose logstash-output-ks3

logstash-output-ks3 (0.0.1)
```

## 开发

### 1. 插件开发测试

#### Code
- 开始前需要JRuby

- 安装依赖
```sh
bundle install
```

### 2. 在 Logstash 运行你的插件

#### 2.1 编译、安装、运行

- 编译

```sh
gem build logstash-output-ks3.gemspec
```

- 安装到logstash

```sh
bin/logstash-plugin install /path/to/logstash-output-ks3-0.1.1-java.gem
```

- 在logstash测试

```bash
./bin/logstash -f config/logstash-sample.conf
```

## 引用
[logstash-output-oss](https://github.com/aliyun/logstash-output-oss)
