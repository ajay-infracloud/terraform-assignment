variable "AWS_ACCESS_KEY" {
    description = "AWS ACCESS KEY"
}

variable "AWS_SECRET_KEY" {
  description = "AWS SECRET KEY"
}

variable "aws_region" {
  type = string
  default = "eu-west-2"
  description = "AWS Region"
}

variable "aws_vpc_cidr_block" {}

variable "default_tags" {}

variable "max_subnet_count" {}

variable "ec2_properties" {}

variable "rds_properties" {}

variable "stack_name" {}
