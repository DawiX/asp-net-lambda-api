data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}

### Policies ###

## Custom

###

### Role
resource "aws_iam_role" "lambda_role" {
  count = var.create_role == true ? 1 : 0
  name  = "${local.lambda_name}_role"
  path  = "/lambdas/"

  tags = merge(var.tags, { "Name" = "${local.lambda_name}_role" })

  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

###

### Attachements

## Custom

## Needed

# AWS X-Ray write only managed policy
resource "aws_iam_role_policy_attachment" "AWSXrayWriteOnlyAccess_attachment" {
  count      = var.create_role == true ? 1 : 0
  role       = aws_iam_role.lambda_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
}

# Provides write permissions to CloudWatch Logs.
resource "aws_iam_role_policy_attachment" "AWSLambdaBasicExecutionRole_attachment" {
  count      = var.create_role == true ? 1 : 0
  role       = aws_iam_role.lambda_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Provides minimum permissions for a Lambda function to execute while accessing a resource within a VPC - create, describe, delete network interfaces and write permissions to CloudWatch Logs.
resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRole_attachment" {
  count      = var.create_role == true ? 1 : 0
  role       = aws_iam_role.lambda_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# Grants read-only access to AWS Lambda service, AWS Lambda console features, and other related AWS services.
resource "aws_iam_role_policy_attachment" "AWSLambda_ReadOnlyAccess_attachment" {
  count      = var.create_role == true ? 1 : 0
  role       = aws_iam_role.lambda_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_ReadOnlyAccess"
}

###
