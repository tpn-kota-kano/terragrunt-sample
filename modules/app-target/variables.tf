variable "common_vars" {
  type = object({
    feature_name_prefix = string
  })
  description = "共通変数"
}

variable "app_source" {
  type = object({
    sqs_arn = string
  })
  description = "app_source"
}
