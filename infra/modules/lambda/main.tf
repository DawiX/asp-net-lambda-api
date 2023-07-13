data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_vpc" "vpc" {
  count = var.vpc_name == "" ? 0 : 1
  tags = {
    Name = var.vpc_name
  }
}

data "aws_subnets" "backend_subnets" {
  count = var.vpc_name == "" ? 0 : 1
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc[count.index].id]
  }
  tags = {
    Scope = var.vpc_be_tag
  }
}
