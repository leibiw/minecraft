module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "20.0"

  cluster_name                   = "sphere"
  cluster_version                = "1.29"
  cluster_endpoint_public_access = true

  cluster_addons = {
     coredns = {
      addon_version               = "v1.11.1-eksbuild.6"
      resolve_conflicts_on_create = "OVERWRITE"
      }

  kube-proxy = {
    resolve_conflicts_on_create = "OVERWRITE"
    }

  vpc-cni = {
    resolve_conflicts_on_create = "OVERWRITE"
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    desire_capacity = 2
    max_capacity    = 3
    instance_types = ["t3.medium"]
  }
}