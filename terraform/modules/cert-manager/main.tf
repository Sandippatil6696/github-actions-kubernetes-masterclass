resource "helm_release" "cert_manager" {

  name             = var.release_name
  namespace        = var.namespace
  create_namespace = true

  repository = "oci://quay.io/jetstack/charts"
  chart      = "cert-manager"
  version    = var.chart_version

  wait = true

  values = [yamlencode({
    crds = {
      enabled = true
    }
    config = {
      enableGatewayAPI = true
    }
  })]
}