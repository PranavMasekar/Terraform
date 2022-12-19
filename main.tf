provider "aws" {
  region = "ap-south-1"
}

variable "vpc-cidr-block" {}
variable "subnet-cidr-block" {}
variable "availability_zone" {}
variable "env_prefix" {}

resource "aws_vpc" "myapp-vpc" {
    cidr_block = var.vpc-cidr-block
    tags = {
      Name = "${var.env_prefix}-vpc"
    }
}

resource "aws_subnet" "myapp-subnet-1" {
  vpc_id = aws_vpc.myapp-vpc.id
  cidr_block = var.subnet-cidr-block
  availability_zone = var.availability_zone
   tags = {
      Name = "${var.env_prefix}-subnet-1"
    }
}

resource "aws_internet_gateway" "myapp-internet-gateway" {
  vpc_id = aws_vpc.myapp-vpc.id
   tags = {
    Name = "${var.env_prefix}-internet-gateway"
  }
}

resource "aws_route_table" "myapp-route-table" {
  vpc_id = aws_vpc.myapp-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-internet-gateway.id
  }
  tags = {
    Name = "${var.env_prefix}-route-table"
  }
}

resource "aws_route_table_association" "myapp-association" {
  subnet_id = aws_subnet.myapp-subnet-1.id
  route_table_id = aws_route_table.myapp-route-table.id
}