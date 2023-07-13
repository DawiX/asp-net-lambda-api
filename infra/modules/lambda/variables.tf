variable "vpc_name" {
  type        = string
  default     = ""
  description = "VPC name where the lambda will be deployed into - Needs to be provided together with Security Group ID"
}

variable "vpc_pub_tag" {
  type    = string
  default = "public"
}

variable "vpc_be_tag" {
  type    = string
  default = "private"
}

variable "vpc_db_tag" {
  type    = string
  default = "database"
}

variable "lambda_prefix" {
  type        = string
  default     = ""
  description = "Lamba naming convention prefix: cxnp- | cxnd- for production or developmemnt version"
}
variable "lambda_name" {
  type        = string
  description = "Scope of the function"
}

variable "s3_payload_bucket" {
  type        = string
  default     = null
  description = "ID (name) of the bucket where Lambda artifacts are stored"
}

variable "s3_payload_key" {
  type        = string
  default     = null
  description = "Path to the Lambda payload ZIP (eg. my/prefix/lambda.zip)"
}

variable "s3_object_version" {
  type        = string
  default     = null
  description = "Lambda payload ZIP's S3 object version."
}

variable "filename" {
  type        = string
  default     = null
  description = "Path to local file to upload to the lambda"
}

variable "source_code_hash" {
  type        = string
  default     = null
  description = "If you want to use source_code_hash to check changes when uploading file to lambda from local `filebase64sha256(file(\"lambda.zip\"))`"
}

variable "handler" {
  type        = string
  description = "Entry point to the Lambda function (consult documentation based on Lambda runtime)"
}

variable "timeout" {
  type        = number
  description = "Lambda timeout in seconds (max 15 min)"
}

variable "memory_size" {
  type        = number
  description = "Memory allocation in MBs"
}

variable "runtime" {
  type        = string
  description = "Lambda runtime see [Runtimes](https://docs.aws.amazon.com/lambda/latest/dg/API_CreateFunction.html#SSS-CreateFunction-request-Runtime)"
}

variable "create_role" {
  type        = bool
  default     = true
  description = "Create default IAM role, disable to be able to provide iam_role ARN"
}

variable "iam_role" {
  type        = string
  default     = ""
  description = "ARN of the IAM role to be associated with the Lambda, if not set default IAM role is generated"
}

variable "security_group_id" {
  type        = string
  default     = ""
  description = "SG Id to be associated with Lambda - if assigned, Lambda will automatically deploy as VPC lambda. Needs to be set together with vpc_name variable"
}

variable "lambda_env_variables" {
  type        = map(any)
  default     = null
  description = "Map of additional environmental variables for the Lambda"
}

variable "invoke_permission_role_principals" {
  type        = list(string)
  default     = []
  description = "List of Role ARNs to give lambda:InvokeFunction permission to the lambda"
}

variable "architectures" {
  type        = list(string)
  default     = ["x86_64"]
  description = "Underlying architecture of deployed lambda - valid are [\"x86_64\"] and [\"arm64\"] "
}

variable "publish" {
  type        = bool
  default     = false
  description = "Whether to automatically publish new versions - enables work with alias version mapping. Enable if you want to use included alias mapping, or some external module for alias handling"
}

variable "aliases" {
  type        = map(any)
  default     = {}
  description = "Map of aliases to add to the lambda { alias_name = version } when version = null, latest version is used. Set publish = true to be able to fix specific versions to alias, otherwise it will be always $LATEST"
}

variable "tags" {
  type        = map(string)
  description = "Map of tags to apply to resources"
}

# Layers

variable "lambda_layers" {
  type = list(object({
    name                = string
    s3_bucket           = optional(string)
    s3_key              = optional(string)
    s3_object_version   = optional(string)
    filename            = optional(string)
    source_code_hash    = optional(string)
    compatible_runtimes = list(string)
  }))
  default = null
  # description = "List of objects defining layers to be created."
  description = <<-EOT
  List of objects defining layers to be created. Supports layer upload either from s3 or local file:
  ```
  [
    {
      name              = "myLayer1"
      s3_bucket         = "some-s3-bucket"
      s3_key            = "some/path/layer1.zip"
      s3_object_version = "somehash"
      compatible_runtimes = [
        "runtime1",
        "runtime1.1"
      ]
    },
    {
      name             = "myLayer2"
      filename         = "someLocalLayer2.zip"
      source_code_hash = "someHash"
      compatible_runtimes = [
        "runtime1.2"
      ]
    }
  ]
  ```
  EOT
}
