resource "aws_lambda_layer_version" "lambda_layer" {
  for_each = var.lambda_layers != null ? {
    for index, layer in var.lambda_layers :
    layer.name => layer
  } : {}

  layer_name = each.value.name

  s3_bucket         = try(each.value.s3_bucket, null)
  s3_key            = try(each.value.s3_key, null)
  s3_object_version = try(each.value.s3_object_version, null)

  filename         = try(each.value.filename, null)
  source_code_hash = try(each.value.source_code_hash, null)

  compatible_runtimes = each.value.compatible_runtimes
}
