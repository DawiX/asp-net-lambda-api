resource "aws_lambda_alias" "dynamic_aliases" {
  for_each = var.aliases

  name             = each.key
  description      = "${each.key} alias"
  function_name    = aws_lambda_function.lambda[0].arn
  function_version = each.value == null ? aws_lambda_function.lambda[0].version : each.value
}
