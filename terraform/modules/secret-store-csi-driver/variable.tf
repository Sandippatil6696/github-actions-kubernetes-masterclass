variable "namespace" {
  default = "skillpulse"
}

variable "oidc_provider" {
  description = "EKS OIDC provider URL for IRSA"
  type        = string
}

variable "environment" {
  description = "Environment name e.g dev, stage, prod"
  type        = string
}