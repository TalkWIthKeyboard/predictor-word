# predictor-word
> `elasticsearch` 扩展 `ik` 和 `pinyin` 插件的 `docker` 镜像，适合直接对生产环境进行部署。

## Version
+ **elasticsearch** -> 5.1.1
+ **ik** -> 5.1.1
+ **lc-pinyin** -> 5.1.1

## Require
+ docker
+ docker-compose
+ npm (因为作者是 `nodejs` 使用者，所以习惯使用 `npm` 进行命令管理，也可以直接使用 `docker-compose cli`)

## Init
+ Clone project

```
$ git clone https://github.com/TalkWIthKeyboard/predictor-word.git
```
+ Build image

```
$ npm run build
```

## Create Index

```
PUT localhost:9200/index

{
  "settings": {
    "analysis": {
      "analyzer": {
        // 汉语转拼音首字母分词
        "ik_letter_smart": {
          "type": "custom",
          "tokenizer": "ik_max_word",
          "filter": [
            "lc_first_letter"
          ]
        },
        // 汉语转拼音全拼分词
        "ik_py_smart": {
          "type": "custom",
          "tokenizer": "ik_max_word",
          "filter": [
            "lc_full_pinyin"
          ]
        },
        // 汉语分词
        "ik_china_english_smart": {
          "type": "custom",
          "tokenizer": "ik_max_word",
          "filter": [
            "stemmer"
          ]
        }
      }
    }
  }
}
```

## Tips
+ 因为作者是将该镜像部署到廉价腾讯云服务器使用，所以对 `elasticsearch` 的内存使用进行了限制（默认是**2G**），如果有充分的资源可以注释掉 `docker-compose.yml` 中的 `ES_JAVA_OPTS: -Xms512m -Xmx512m`
+ 关闭了访问需要登录的设置：`xpack.security.enabled`
+ 添加新的分析器：
  + 关闭 `index`
    ```
    POST localhost:9200/index/_close
    ```
  + 添加分析器
    ```
    PUT localhost:9200/index/_settings

    {
      "analysis": {
        "analyzer": {
          "newAnalyzer": {
            "type": "custom",
            "tokenizer": "ik_max_word",
          }
        }
      }
    }
    ```
  + 开启 `index`
    ```
    POST localhost:9200/index/_open
    ```