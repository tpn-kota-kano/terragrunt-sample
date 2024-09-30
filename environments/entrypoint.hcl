locals {
  service = "replace_me"

  # terragrunt.hclのあるディレクトリとentrypoint.hclの相対パスから、環境名、テナント名、モジュール名を取得する
  relpath       = replace(get_original_terragrunt_dir(), get_terragrunt_dir(), "")
  path_segments = slice(split("/", local.relpath), 1, length(split("/", local.relpath)))
  env           = length(local.path_segments) > 0 ? local.path_segments[0] : ""
  tenant        = length(local.path_segments) > 1 ? local.path_segments[1] : ""
  module        = length(local.path_segments) > 2 ? local.path_segments[2] : ""

  env_name_prefix     = "${local.service}-${local.env}"
  feature_name_prefix = "${local.service}-${local.env}-${local.tenant}"
  source_suffix       = "${local.module}"

  regions = {
    tokyo = "ap-northeast-1"
  }
}
