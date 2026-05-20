variable "namespace" {
  type    = string
  default = "monitoring"
}

variable "grafana_service_type" {
  type    = string
  default = "LoadBalancer"
}