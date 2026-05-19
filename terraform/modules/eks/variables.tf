variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnets" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "intra_subnets" {
  description = "Control plane subnet IDs"
  type        = list(string)
}

variable "node_instance_type" {
  description = "Worker node instance type"
  type        = string
}

variable "node_desired_count" {
  description = "Desired worker node count"
  type        = number
}

variable "node_min_count" {
  description = "Minimum worker node count"
  type        = number
}

variable "node_max_count" {
  description = "Maximum worker node count"
  type        = number
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
}