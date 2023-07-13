resource "aws_lambda_function" "lambda" {
  count         = var.security_group_id == "" ? 1 : 0
  function_name = local.lambda_name
  role          = var.create_role == true ? aws_iam_role.lambda_role[0].arn : var.iam_role
  handler       = var.handler

  s3_bucket         = var.s3_payload_bucket
  s3_key            = var.s3_payload_key
  s3_object_version = var.s3_object_version

  filename         = var.filename
  source_code_hash = var.source_code_hash

  runtime     = var.runtime
  memory_size = var.memory_size
  timeout     = var.timeout

  architectures = var.architectures

  publish = var.publish

  layers = [for layer in aws_lambda_layer_version.lambda_layer : layer.arn]

  tracing_config {
    mode = "Active"
  }

  #checkov:skip=CKV_AWS_173:Env vars do not need to be encrypted
  dynamic "environment" {
    for_each = local.lambda_env_variables
    content {
      variables = environment.value
    }
  }

  tags = merge(var.tags, { "Name" = local.lambda_name })
}

resource "aws_lambda_function" "vpc_lambda" {
  count         = var.security_group_id == "" || var.vpc_name == "" ? 0 : 1
  function_name = local.lambda_name
  role          = var.create_role == true ? aws_iam_role.lambda_role[0].arn : var.iam_role
  handler       = var.handler

  s3_bucket         = var.s3_payload_bucket
  s3_key            = var.s3_payload_key
  s3_object_version = var.s3_object_version

  filename         = var.filename
  source_code_hash = var.source_code_hash

  runtime     = var.runtime
  memory_size = var.memory_size
  timeout     = var.timeout

  architectures = var.architectures

  publish = var.publish

  layers = [for layer in aws_lambda_layer_version.lambda_layer : layer.arn]

  vpc_config {
    security_group_ids = [var.security_group_id]
    subnet_ids         = toset(data.aws_subnets.backend_subnets[count.index].ids)
  }

  tracing_config {
    mode = "Active"
  }

  dynamic "environment" {
    for_each = local.lambda_env_variables
    content {
      variables = environment.value
    }
  }

  tags = merge(var.tags, { "Name" = local.lambda_name })
}

resource "aws_lambda_permission" "lambda_invoke_permission" {
  for_each      = toset(var.invoke_permission_role_principals)
  function_name = var.security_group_id == "" ? aws_lambda_function.lambda[0].arn : aws_lambda_function.vpc_lambda[0].arn
  action        = "lambda:InvokeFunction"
  principal     = each.value
}
