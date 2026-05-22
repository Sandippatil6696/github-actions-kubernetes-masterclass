variable "namespace" {
  description = "ArgoCD namespace"
  type        = string
  default     = "argocd"
}

variable "service_type" {
  description = "ArgoCD service type"
  type        = string
  default     = "LoadBalancer"
}

variable "eks_dependency" {
  description = "Dependency on EKS module"
}