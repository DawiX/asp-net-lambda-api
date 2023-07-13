resource "aws_cloudwatch_log_group" "lambda_log_group" {
  #checkov:skip=CKV_AWS_158:No KMS encryption of log group needed
  name              = "/aws/lambda/${local.lambda_name}"
  retention_in_days = 180
}
