#Loki Stack (Loki + Promtail)
resource "helm_release" "loki" {
  name             = "loki"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "loki-stack"
  namespace        = var.namespace
  create_namespace = true

  wait    = true
  timeout = 1200
  atomic  = true
  wait_for_jobs = true

  values = [yamlencode({
    loki = {
      enabled = true
      persistence = {
        enabled = true
        size    = "2Gi"
        storageClassName = "gp2"
      }
    }
    promtail = {
      enabled = true
    }
  })]
}

#Kube Prometheus Stack (Prometheus + Alertmanager + Grafana)
resource "helm_release" "kube_prometheus" {
  name             = "kube-prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = var.namespace
  create_namespace = true

  wait    = true
  timeout = 1200
  atomic  = true
  wait_for_jobs = true

  

  values = [yamlencode({
    grafana = {
      service = {
        type = "ClusterIP" # same as --set grafana.service.type=LoadBalancer
      }
      additionalDataSources = [
        {
          name   = "Loki"
          type   = "loki"
          access = "proxy"
          url    = "http://loki.${var.namespace}.svc.cluster.local:3100"
          isDefault = false
          jsonData = {
            maxLines = 1000
          }
        }
      ]

     

    }
  })]

 
}

# OpenTelemetry Collector
resource "helm_release" "otel_collector" {
  name             = "otel-collector"
  repository       = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart            = "opentelemetry-collector"
  namespace        = var.namespace
  create_namespace = true

  wait    = true
  timeout = 600

  values = [file("${path.module}/otel-config.yml")]

  depends_on = [
    helm_release.loki,
    helm_release.kube_prometheus,
  ]
}