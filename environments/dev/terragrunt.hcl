locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("entrypoint.hcl")).locals
}

# バリデーションフックの設定
terraform {
  before_hook "validate_common_vars" {
    commands = ["init", "apply"]

    # 正規表現パターン (空文字、小文字アルファベットとハイフンのみ、かつ最後がハイフンで終わってもよい)
    execute = [
      "bash", "-c", <<EOT
        pattern="^$|^[a-z0-9]+(-[a-z0-9]+)*-?$"

        # 'feature_name_prefix' のバリデーション
        if ! echo "${local.common_vars.feature_name_prefix}" | grep -qE "$pattern"; then
          echo "Error: '${local.common_vars.feature_name_prefix}' does not conform to pattern '$pattern'."
          exit 1
        fi

        # 'source_suffix' のバリデーション
        if ! echo "${local.common_vars.source_suffix}" | grep -qE "$pattern"; then
          echo "Error: '${local.common_vars.source_suffix}' does not conform to pattern '$pattern'."
          exit 1
        fi

        echo "Validation passed."
      EOT
    ]
  }
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket  = "${local.common_vars.env_name_prefix}-terraform-backend"
    region  = "${local.common_vars.regions["tokyo"]}"
    profile = "${local.common_vars.env_name_prefix}"
    key     = "${path_relative_to_include()}/terraform.tfstate"
    encrypt = true

    dynamodb_table = "${local.common_vars.env_name_prefix}-terraform-lock-table"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
  provider "aws" {
    region  = "${local.common_vars.regions["tokyo"]}"
    profile = "${local.common_vars.env_name_prefix}"
    default_tags {
      tags = {
        TerraformDefaultTag = "${local.common_vars.env_name_prefix}-create-by-terraform"
      }
    }
  }
  EOF
}
