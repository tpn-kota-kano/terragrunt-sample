variable "common_vars" {
  type = object({
    feature_name_prefix = string
  })
  description = "共通変数"
}

variable "app_source" {
  type = object({
    sqs_id  = string
    sqs_arn = string
  })
  description = "app_source"
}

variable "app_target" {
  type = object({
    sqs_id  = string
    sqs_arn = string
  })
  description = "app_target"
}
