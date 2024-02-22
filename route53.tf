provider "aws" {
  region = "us-east-1"
}

variable "cluster_name" {
  description = "Name of your EKS cluster"
  type        = string
  default     = "sphere"
}

variable "dns_zone_name" {
  description = "Name of your DNS zone"
  type        = string
  default     = "spherevc.click"
}

data "aws_route53_zone" "dns_zone" {
  name         = var.dns_zone_name
  private_zone = false  # Set to true if it's a private hosted zone
}

resource "aws_route53_record" "eks_cluster_record" {
  name    = var.cluster_name
  type    = "CNAME"
  zone_id = data.aws_route53_zone.dns_zone.id
  ttl     = 300
  records = [module.eks.cluster_endpoint]
}
