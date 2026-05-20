resource "helm_release" "cert_manager" {
  name             = var.release_name
  namespace        = var.namespace
  create_namespace = true

  repository = "oci://quay.io/jetstack/charts"
  chart      = "cert-manager"
  version    = var.chart_version

  wait    = true
  timeout = 600

  set {
    name  = "crds.enabled"
    value = "true"
  }

  set {
    name  = "config.enableGatewayAPI"
    value = "true"
  }
}