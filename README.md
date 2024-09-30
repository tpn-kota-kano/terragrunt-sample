# Terragruntサンプルコード

Terragruntを利用してAWSリソースを作成するためのサンプルコード

## 構築される主なAWSリソース

- sourceSQS
- targetSQS
- Eventbridge pipes
- cloudwatch logs

sourceSQSとtargetSQSをEventbridge pipesで接続し、メッセージの送受信ができるようにしたサンプルアプリ

## 動作確認手順

### リソース名のprefixに使用される変数を変更

S3バケット名などの重複を防ぐため`/workspace/environments/entrypoint.hcl`のservice変数を下記のように変更  
※`usernameyyyymmdd`は任意のuniqueな文字列（小文字英数字ハイフン可）を指定する

```
@@ -1,5 +1,5 @@
 locals {
-  service = "replace_me"
+  service = "usernameyyyymmdd"
 
   # terragrunt.hclのあるディレクトリとentrypoint.hclの相対パスから、環境名、テナント名、モジュール名を取得する
   relpath       = replace(get_original_terragrunt_dir(), get_terragrunt_dir(), "")
```

### AWSの認証情報設定

```sh
# `usernameyyyymmdd`は前の手順で指定したuniqueな文字列
$ aws configure --profile usernameyyyymmdd-dev
```

### Terragruntで利用する情報の初期化（S3バケット、DynamoDBテーブル、backend.tf、provider.tf）

```sh
$ cd /workspace/environments/dev

$ terragrunt init
```

### Terragruntでリソースを構築

```sh
$ cd /workspace/environments/dev/tenant

$ terragrunt run-all apply
```

### 構築されたリソースをAWSコンソールから確認する

[Amazon SQS](https://ap-northeast-1.console.aws.amazon.com/sqs/v3/home)

### Terragruntでリソースを削除

```sh
$ cd /workspace/environments/dev/tenant

$ terragrunt run-all destroy
```
