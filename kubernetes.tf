provider "kubernetes" {
  host                   = "https://54E7E67A29A55CA40E1664F579573C13.gr7.us-east-1.eks.amazonaws.com"
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

data "aws_eks_cluster" "sphere" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "sphere" {
  name = module.eks.cluster_name
}

data "aws_caller_identity" "current" {}

locals {
  aws_account_id = data.aws_caller_identity.current.account_id
  aws_user_arn   = "arn:aws:iam::${local.aws_account_id}:user/leibiw"
}

resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapUsers = <<EOF
- userarn: ${local.aws_user_arn}
  username: leibiw
  groups:
  - system:masters
EOF
  }

  depends_on = [module.eks.cluster_name]
}