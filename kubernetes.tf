provider "kubernetes" {
  host                   = "https://787CD9B7FE2B8CEFF2D7B66312C82F68.gr7.us-east-1.eks.amazonaws.com"
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}