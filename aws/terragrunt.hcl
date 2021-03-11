locals {
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region = "${local.region_vars.locals.region}"
  profile = "${local.region_vars.locals.profile}"
}
EOF
}

generate "common_variables" {
  path = "common_variables.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF

%{ for key, value in local.region_vars.locals ~}
variable "${key}" {
  default = "${value}"
}

%{ endfor ~}
%{ for key, value in local.common_vars.locals ~}
variable "${key}" {
  default = "${value}"
}
%{ endfor ~}

EOF
}

remote_state {
  backend = "s3"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    bucket     = "${local.region_vars.locals.state_files_bucket_name}"
    prefix     = "${path_relative_to_include()}"
    key        = "terraform.tfstate"
    region     = "${local.region_vars.locals.backend_region}"
  }
}

terraform {
  extra_arguments "conditional_vars" {
    commands = [
      "apply",
      "plan",
      "import",
      "push",
      "refresh",
      "destroy",
    ]
  }
}

inputs = merge(
  local.region_vars.locals,
  local.common_vars.locals,
)
