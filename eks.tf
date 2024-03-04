module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "20.0"

  cluster_name                   = "sphere"
  cluster_version                = "1.29"
  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  eks_managed_node_groups = {
    green = {
      use_custom_launch_template = false
      min_size     = 1
      max_size     = 10
      desired_size = 1

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
    }

  # Fargate Profile(s)
    fargate_profiles = {
      default = {
        name = "default"
        selectors = [
        {
          namespace = "default"
         }
        ]
      }
   }
  }
  
  cluster_security_group_additional_rules = {
    ec2_ingress = {
      description                  = "Allow EC2 Ingress"
      from_port                    = "443"
      to_port                      = "443"
      type                         = "ingress"
      protocol                     = "tcp"
      source_security_group_id     = aws_security_group.management_node_sg.id
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}