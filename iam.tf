data "aws_iam_role" "eks_cluster_role" {
  name = "sphere-cluster-20240308193610342300000002"
}

data "aws_iam_role" "fargate_profile_role" {
  name = "<fargate-profile-role-name>"
}

data "aws_iam_role" "green_node_group_role" {
  name = "<green-node-group-role-name>"
}