module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }

  # Add this block to create an internet gateway
  create_igw = true

  # Enable auto-assign public IP for the private subnets
  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster}" = "shared"
    "kubernetes.io/role/internal-elb"        = "1"
    "map_public_ip_on_launch"                = "true"
  }
}

resource "aws_route" "public_ip_route" {
  count                  = length(module.vpc.private_route_table_ids)
  route_table_id         = module.vpc.private_route_table_ids[count.index]
  destination_cidr_block = "73.70.24.45/32"
  gateway_id             = module.vpc.igw_id
}