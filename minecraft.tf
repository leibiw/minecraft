# Kubernetes provider configuration
data "aws_eks_cluster" "default" {
  name = "sphere"
}

data "aws_eks_cluster_auth" "default" {
  name = "sphere"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.default.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.default.token
}

# Minecraft deployment
resource "kubernetes_deployment" "minecraft" {
  metadata {
    name = "minecraft"
    labels = {
      app = "minecraft"
    }
  }

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