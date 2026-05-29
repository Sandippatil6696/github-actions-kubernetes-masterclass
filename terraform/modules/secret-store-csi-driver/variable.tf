variable "namespace" {
  default = "skillpulse"
}

variable "oidc_provider" {
  description = "EKS OIDC provider URL for IRSA"
  type        = string
}