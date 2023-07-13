resource "aws_s3_bucket" "test_bucket" {
  bucket = var.bucket_name

  tags = merge(
      var.tags,
      {
        "Name" = var.bucket_name
      },
    )
}

resource "aws_s3_bucket_lifecycle_configuration" "test_bucket" {
  bucket = aws_s3_bucket.test_bucket.id

  rule {
    id     = "Keep for 30 days"
    status = "Enabled"

    expiration {
      days = 30
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "test_bucket" {
  bucket = aws_s3_bucket.test_bucket.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.test_bucket.id
  policy = data.aws_iam_policy_document.lambda_allow_read_only.json
}

data "aws_iam_policy_document" "lambda_allow_read_only" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.test_bucket.arn,
      "${aws_s3_bucket.test_bucket.arn}/*",
    ]

    condition {
      test = "StringEquals"
      variable = "AWS:SourceArn"
      values = [
        "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:function:${var.lambda_name}",
      ]
    }
  }
}

resource "aws_s3_object" "this" {
  for_each = toset(local.s3_files)
  bucket = aws_s3_bucket.test_bucket.id
  key    = basename(each.key)
  source = each.key
  etag = filemd5(each.key)
}
