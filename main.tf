provider "aws" {
  region = "ap-south-1"
}

variable "subnet-cidr-block" {
  description = "Subnet cidr block"
  default = "10.0.10.0/24"
  type = string
}

variable "vpc-cidr-block" {
  description = "VPC vidr block"
  default = "10.0.0.0/16"
  type = string
}

variable "environment" {
  description = "Deployment Environment"
}

#! CREATING A VPC IN AWS

resource "aws_vpc" "development-vpc" {
    cidr_block = var.vpc-cidr-block
    tags = {
      Name = var.environment
    }
}

#! CREATING SUBNET IN ABOVE VPC

resource "aws_subnet" "devlopment-subnet-1" {
  vpc_id = aws_vpc.development-vpc.id
  cidr_block = var.subnet-cidr-block
  availability_zone = "ap-south-1a"
   tags = {
      Name = "subnet-1-dev"
    }
}

#! GETTING EXISTING RESOURCE IN AWS

# data "aws_vpc" "existing-vpc" {
#   default = true
# }

#! CREATING SUBNET IN EXISTING VPC

# resource "aws_subnet" "devlopment-subnet-2" {
#   vpc_id = data.aws_vpc.existing-vpc.id
#   cidr_block = "172.31.48.0/20"
#   availability_zone = "ap-south-1a"
#    tags = {
#       Name = "subnet-2-default"
#     }
# }\

#! OUTPUT VARIABLES AFTER TERRAFORM APPLY

output "dev-vpc-id" {
  value = aws_vpc.development-vpc.id
}

output "dev-subnet-id" {
  value = aws_subnet.devlopment-subnet-1.id
}