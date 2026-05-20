variable "release_name" {
  type    = string
  default = "eg"
}

variable "namespace" {
  type    = string
  default = "envoy-gateway-system"
}

variable "service_type" {
  type    = string
  default = "LoadBalancer"
}

variable "replicas" {
  type    = number
  default = 1
}

variable "gateway_api_version" {
  type    = string
  default = "v1.2.1"
}

variable "envoy_gateway_version" {
  type    = string
  default = "v1.2.6"
}

variable "cluster_name" {
  type = string
}

variable "aws_region" {
  type = string
}

