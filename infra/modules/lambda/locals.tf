locals {
  lambda_name          = "${var.lambda_prefix}${var.lambda_name}"
  lambda_env_variables = var.lambda_env_variables == null ? [] : [var.lambda_env_variables]
}
