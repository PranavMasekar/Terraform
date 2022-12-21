provider "aws" {
  region = "ap-south-1"
}

variable "vpc-cidr-block" {}
variable "subnet-cidr-block" {}
variable "availability_zone" {}
variable "env_prefix" {}
variable "ip-address" {}
variable "instance-type" {}
variable "public-key-path" {}
variable "private-key-path" {}

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

resource "aws_default_route_table" "main-route-table" {
  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-internet-gateway.id
  }
  tags = {
    Name = "${var.env_prefix}-main-route-table"
  }
}

resource "aws_security_group" "myapp-security-group" {
  name = "myapp-security-group"
  vpc_id = aws_vpc.myapp-vpc.id

  ingress  {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.ip-address]
  }

  ingress  {
    from_port = 8000
    to_port = 8000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "${var.env_prefix}-security-group"
  }
}

data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

output "aws-ami-id" {
  value = data.aws_ami.latest-amazon-linux-image.id
}

output "ec-2-public-ip" {
  value = aws_instance.myapp-server.public_ip
}

resource "aws_key_pair" "ssh-key" {
  key_name = "server-key"
  public_key = file(var.public-key-path)
}

resource "aws_instance" "myapp-server" {
  ami = data.aws_ami.latest-amazon-linux-image.id
  instance_type = var.instance-type

  subnet_id = aws_subnet.myapp-subnet-1.id
  vpc_security_group_ids = [aws_security_group.myapp-security-group.id]
  availability_zone = var.availability_zone
  associate_public_ip_address = true
  key_name = aws_key_pair.ssh-key.key_name

  user_data = file("entry-script.sh")
 
  tags = {
    Name = "${var.env_prefix}-EC-2-server"
  }
}