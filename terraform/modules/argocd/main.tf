resource "helm_release" "argocd" {

  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"

  namespace        = var.namespace
  create_namespace = true

  values = [
    yamlencode({

      server = {
        service = {
          type = var.service_type
        }
      }

      configs = {
        params = {
          "server.insecure" = true
        }
      }

    })
  ]

  depends_on = [var.eks_dependency]
}