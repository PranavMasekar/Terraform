provider "aws" {
  region = "ap-south-1"
  access_key = "<YOUR-ACCESS-KEY>"
  secret_key = "<YOUR-SECRET-KERY>"
}

#! CREATING A VPC IN AWS

resource "aws_vpc" "development-vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "development"
    }
}

#! CREATING SUBNET IN ABOVE VPC

resource "aws_subnet" "devlopment-subnet-1" {
  vpc_id = aws_vpc.development-vpc.id
  cidr_block = "10.0.10.0/24"
  availability_zone = "ap-south-1a"
   tags = {
      Name = "subnet-1-dev"
    }
}

#! GETTING EXISTING RESOURCE IN AWS

data "aws_vpc" "existing-vpc" {
  default = true
}

#! CREATING SUBNET IN EXISTING VPC

resource "aws_subnet" "devlopment-subnet-2" {
  vpc_id = data.aws_vpc.existing-vpc.id
  cidr_block = "172.31.48.0/20"
  availability_zone = "ap-south-1a"
   tags = {
      Name = "subnet-2-default"
    }
}