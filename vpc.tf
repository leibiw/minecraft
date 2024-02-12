locals {
  region                = "us-east-1"
  name                  = "minecraft-server"
  vpc_cidr              = "10.0.0.0/16"
  azs                   = ["us-east-1a", "us-east-1b"]
  public_subnets        = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets       = ["10.0.100.0/24", "10.0.300.0/24"]

  common_tags           = {
    terraform           = true
    enviroment          = "dev"
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"



  name              = local.name
  cidr              = local.vpc_cidr
  azs               = local.azs
  private_subnets   = local.private_subnets
  public_subnets    = local.public_subnets

  enable_nat_gateway = true

  tags = merge(
    local.common_tags, {
        name    = local.name
    }
  )
}