# Minecraft Server Deployment
resource "kubernetes_deployment" "minecraft" {
  metadata {
    name = "minecraft-server"
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

          env {
            name  = "EULA"
            value = "TRUE"
          }
        }
      }
    }
  }
}