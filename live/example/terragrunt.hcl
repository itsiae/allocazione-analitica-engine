include {
  path   = find_in_parent_folders()
}

locals{
  module = "example"
  config = yamldecode(file(find_in_parent_folders("config.yaml")))
  stage   = yamldecode(file("../_envs/${get_env("ENV")}.yaml"))
}

inputs = {
  # module configuration variables
  account_id              = get_aws_account_id()
  region                  = local.config.region.primary
  project                 = local.config.project_name
  module                  = local.module
  env                     = local.stage.env

  variable_from_github_env = local.stage.variable_from_github_env
  variable_defined_here     = local.stage.variable_defined_here
}
