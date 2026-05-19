variable "cluster_version" {
  type = string
}

variable "node_instance_type" {
  type = string
}

variable "node_desired_count" {
  type = number
}

variable "node_min_count" {
  type = number
}

variable "node_max_count" {
  type = number
}

variable "aws_region" {
  type = string
  default = "us-west-2"
}