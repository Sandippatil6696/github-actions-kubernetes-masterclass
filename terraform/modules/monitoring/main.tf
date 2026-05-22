resource "helm_release" "kube_prometheus" {
  name             = "kube-prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = var.namespace
  create_namespace = true

  wait    = true
  timeout = 1200

  values = [yamlencode({
    grafana = {
      service = {
        type = "LoadBalancer" # same as --set grafana.service.type=LoadBalancer
      }
    }
  })]

 
}