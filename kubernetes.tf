# Define the Kubernetes ConfigMap for CoreDNS
resource "kubernetes_config_map" "coredns" {
 metadata {
    name      = "coredns"
    namespace = "kube-system"
 }

 data = {
    "Corefile" = <<EOF
.:53 {
    errors
    health {
       lameduck 5s
    }
    ready
    kubernetes cluster.local in-addr.arpa ip6.arpa {
       pods insecure
       upstream
       fallthrough in-addr.arpa ip6.arpa
    }
    prometheus :9153
    forward . /etc/resolv.conf
    cache 30
    loop
    reload
    loadbalance
}
EOF
 }
}

# Define a null_resource to apply the CoreDNS configuration
resource "null_resource" "apply_coredns_config" {
 depends_on = [kubernetes_config_map.coredns] # Ensure this runs after the ConfigMap is created

 provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/coredns-configmap.yaml"
 }
}
