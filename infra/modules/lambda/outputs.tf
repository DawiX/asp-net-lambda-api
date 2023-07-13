
output "lambda_id" {
  value       = var.security_group_id == "" ? aws_lambda_function.lambda[0].id : aws_lambda_function.vpc_lambda[0].id
  description = "Lambda ID"
}

output "lambda_arn" {
  value       = var.security_group_id == "" ? aws_lambda_function.lambda[0].arn : aws_lambda_function.vpc_lambda[0].arn
  description = "Lambda ARN"
}

output "lambda_function_name" {
  value       = var.security_group_id == "" ? aws_lambda_function.lambda[0].function_name : aws_lambda_function.vpc_lambda[0].function_name
  description = "Lambda function name"
}

output "lambda_function_version" {
  value       = var.security_group_id == "" ? aws_lambda_function.lambda[0].version : aws_lambda_function.vpc_lambda[0].version
  description = "Latest version that lambda was deployed as - $LATEST or latest published version, depending on `publish = true | false`"
}

output "lambda_invoke_arn" {
  value       = var.security_group_id == "" ? aws_lambda_function.lambda[0].invoke_arn : aws_lambda_function.vpc_lambda[0].invoke_arn
  description = "Lambda invocation ARN - used for example in API GW integration mapping"
}

output "aliases" {
  value = {
    for k, v in var.aliases :
    k => {
      alias   = k
      version = v == null ? aws_lambda_function.lambda[0].version : v
    }
  }
  description = <<-EOT
  Returns object like this:
  ```
  {
    prod = {
      alias   = "prod"
      version = "1"
    }
    test = {
      alias   = "test"
      version = "3"
    }
    etc...
  }
  ```
  EOT
}

output "layers" {
  value = [for layer in aws_lambda_layer_version.lambda_layer : layer.arn]
}
