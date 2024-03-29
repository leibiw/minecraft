provider "kubernetes" {
  config_path = "C:\\Users\\vchin\\minecraft\\kubeconfig" 
}

resource "null_resource" "apply_yaml" {
  provisioner "local-exec" {
    command     = "cat C:\\Users\\vchin\\minecraft\\minecraft-deployment.yaml C:\\Users\\vchin\\minecraft\\minecraft-service.yaml | kubectl apply -f -"
    working_dir = path.module
  }

  depends_on = [module.eks] 
}
