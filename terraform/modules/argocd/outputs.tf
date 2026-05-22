output "argocd_namespace" {
  value = helm_release.argocd.namespace
}

output "argocd_release_name" {
  value = helm_release.argocd.name
}