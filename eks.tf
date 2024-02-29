module "eks" {
 source = "terraform-aws-modules/eks/aws"
 version = "20.0"

 cluster_name                   = "sphere"
 cluster_version                = "1.29"
 cluster_endpoint_public_access = true

 cluster_addons = {
    coredns = {
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

}
