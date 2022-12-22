resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc-cidr-block
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

module "my-app-subnet" {
  source                 = "./modules/subnet"
  subnet-cidr-block      = var.subnet-cidr-block
  availability_zone      = var.availability_zone
  env_prefix             = var.env_prefix
  vpc_id                 = aws_vpc.myapp-vpc.id
  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
}

module "myapp-server" {
  source            = "./modules/server"
  vpc_id            = aws_vpc.myapp-vpc.id
  ip-address        = var.ip-address
  env_prefix        = var.env_prefix
  image_name        = var.image_name
  public-key-path   = var.public-key-path
  instance-type     = var.instance-type
  subnet_id         = module.my-app-subnet.subnet.id
  availability_zone = var.availability_zone
}
