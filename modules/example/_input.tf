variable "account_id" {
  description = "The AWS Account number used for deploying Terraform"
  type        = string
}

variable "region" {
  description = "Primary AWS Region to be used"
  type        = string
}

variable "project" {
  description = "The Project Name"
  type        = string
}

variable "env" {
  description = "The current environment"
  type        = string
}

variable "module" {
  description = "The Descriptive Name for this module"
  type        = string
}

variable "variable_from_github_env" {
  description = "A variable defined in the GitHub environment"
  type        = string
}

variable "variable_defined_here" {
  description = "A variable defined in the terragrunt.hcl file"
  type        = string

}
