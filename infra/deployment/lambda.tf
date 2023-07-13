module "lambda" {
  source = "../modules/lambda/"

  lambda_name      = var.lambda_name
  handler          = "asp-lambda"
  timeout          = 30
  memory_size      = 256
  runtime          = "dotnet6"
  filename         = "../../asp-lambda.zip"
  source_code_hash = filebase64sha256("../../asp-lambda.zip")

  create_role = false
  iam_role    = aws_iam_role.lambda_role.arn

  architectures = ["x86_64"]

  tags = var.tags
}
