#############################################
# Gateway API CRDs
#############################################

resource "null_resource" "gateway_api_crds" {

  provisioner "local-exec" {

    interpreter = ["/bin/bash", "-c"]

    command = <<EOT

    aws eks update-kubeconfig --name ${var.cluster_name} --region ${var.aws_region}

    kubectl apply --server-side \
    -f https://github.com/kubernetes-sigs/gateway-api/releases/download/${var.gateway_api_version}/standard-install.yaml
EOT
  }

  triggers = {
    gateway_api_version = var.gateway_api_version
  }

}

#############################################
# Envoy Gateway Helm Install
#############################################

resource "helm_release" "envoy_gateway" {

  name             = var.release_name
  namespace        = var.namespace
  create_namespace = true

  repository = "oci://docker.io/envoyproxy"
  chart      = "gateway-helm"
  version    = var.envoy_gateway_version

  skip_crds = true

  wait    = true
  timeout = 1200

  values = [
    yamlencode({

      deployment = {
        replicas = var.replicas
      }

      service = {
        type = var.service_type
      }

    })
  ]

  depends_on = [
    null_resource.gateway_api_crds
  ]
}

#############################################
# Envoy Gateway Extension CRDs
#############################################

resource "null_resource" "envoy_extension_crds" {

  depends_on = [
    helm_release.envoy_gateway
  ]

  provisioner "local-exec" {

    interpreter = ["/bin/bash", "-c"]

    command = <<EOT

rm -rf /tmp/eg-chart

helm pull oci://docker.io/envoyproxy/gateway-helm \
  --version ${var.envoy_gateway_version} \
  --untar \
  -d /tmp/eg-chart

kubectl apply --server-side \
-f /tmp/eg-chart/gateway-helm/crds/generated/

kubectl rollout restart deployment envoy-gateway \
-n ${var.namespace}

EOT
  }

  triggers = {
    envoy_gateway_version = var.envoy_gateway_version
  }
}