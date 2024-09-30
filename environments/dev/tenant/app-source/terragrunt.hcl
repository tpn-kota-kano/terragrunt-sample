include "root" {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("entrypoint.hcl")).locals
}

terraform {
  source = "${path_relative_from_include()}/../../modules/${local.common_vars.source_suffix}"
}

inputs = {
  common_vars = local.common_vars
}
