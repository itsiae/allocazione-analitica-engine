output "variable_from_github_env" {
  value = "this is the name of the github user = ${var.variable_from_github_env}"
}

output "variable_defined_here" {
  value = var.variable_defined_here
}
