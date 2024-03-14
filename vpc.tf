module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "sphere-az"
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

  # Add this block to create a route table for the public subnets
  public_route_table_tags = {
    Name = "sphere-az-public"
  }
}

# Lookup the "sphere-az-private-us-east-1a" route table
data "aws_route_table" "private_us_east_1a" {
  vpc_id = module.vpc.vpc_id
  filter {
    name   = "tag:Name"
    values = ["sphere-az-private-us-east-1a"]
  }
}

# Add a route for the public IP "73.70.24.45/32" to the "sphere-az-private-us-east-1a" route table
resource "aws_route" "public_ip_route_private_us_east_1a" {
  route_table_id         = data.aws_route_table.private_us_east_1a.id
  destination_cidr_block = "73.70.24.45/32"
  gateway_id             = module.vpc.igw_id
}

# Lookup the "sphere-az-private-us-east-1b" route table
data "aws_route_table" "private_us_east_1b" {
  vpc_id = module.vpc.vpc_id
  filter {
    name   = "tag:Name"
    values = ["sphere-az-private-us-east-1b"]
  }
}

# Add a route for the public IP "73.70.24.45/32" to the "sphere-az-private-us-east-1b" route table
resource "aws_route" "public_ip_route_private_us_east_1b" {
  route_table_id         = data.aws_route_table.private_us_east_1b.id
  destination_cidr_block = "73.70.24.45/32"
  gateway_id             = module.vpc.igw_id
}

# Lookup the "sphere-az-private-us-east-1c" route table
data "aws_route_table" "private_us_east_1c" {
  vpc_id = module.vpc.vpc_id
  filter {
    name   = "tag:Name"
    values = ["sphere-az-private-us-east-1c"]
  }
}

# Add a route for the public IP "73.70.24.45/32" to the "sphere-az-private-us-east-1c" route table
resource "aws_route" "public_ip_route_private_us_east_1c" {
  route_table_id         = data.aws_route_table.private_us_east_1c.id
  destination_cidr_block = "73.70.24.45/32"
  gateway_id             = module.vpc.igw_id
}