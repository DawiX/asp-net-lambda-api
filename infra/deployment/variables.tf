variable "region" {
  type = string
}

variable "aws_profile" {
  type = string
}

variable "lambda_name" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "tags" {
  type = map(string)
}
