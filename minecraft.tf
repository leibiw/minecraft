# Kubernetes provider configuration
provider "kubernetes" {
  # Use the kubeconfig output from the EKS module
  config_path = "${path.module}/kubeconfig"
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