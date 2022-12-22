module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = var.vpc-cidr-block

  azs             = [var.availability_zone]
  public_subnets  = [var.subnet-cidr-block]

  tags = {
    Name = "${var.env_prefix}-vpc"
  }

  public_subnet_tags = {
    Name = "${var.env_prefix}-subnet-1"
  }
}

module "myapp-server" {
  source            = "./modules/server"
  vpc_id            = module.vpc.vpc_id
  ip-address        = var.ip-address
  env_prefix        = var.env_prefix
  image_name        = var.image_name
  public-key-path   = var.public-key-path
  instance-type     = var.instance-type
  subnet_id         = module.vpc.public_subnets[0]
  availability_zone = var.availability_zone
}
