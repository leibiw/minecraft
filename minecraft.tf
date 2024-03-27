# Minecraft deployment
resource "kubernetes_deployment" "minecraft" {
  metadata {
    name = "minecraft"
    labels = {
      app = "minecraft"
    }
  }

  depends_on = [module.eks]  # Wait for EKS cluster creation

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "minecraft"
      }
    }

    template {
      metadata {
        labels = {
          app = "minecraft"
        }
      }

      spec {
        container {
          image = "itzg/minecraft-server"
          name  = "minecraft"

          port {
            container_port = 25565
          }

          env {
            name  = "EULA"
            value = "TRUE"
          }
        }
      }
    }
  }
}

# Kubernetes provider configuration
provider "kubernetes" {
    host                   = data.aws_eks_cluster.default.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.default.token
}


# Retrieve EKS cluster information
data "aws_eks_cluster" "default" {
  name = local.cluster
}

data "aws_eks_cluster_auth" "default" {
  name = local.cluster
}