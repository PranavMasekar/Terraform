provider "aws" {
  region = "ap-south-1"
}

variable "vpc-cidr-block" {}
variable "env_prefix" {}

resource "aws_vpc" "Testing-vpc" {
  cidr_block = var.vpc-cidr-block
  tags = {
    Name = "Test-${var.env_prefix}-vpc"
  }
}
