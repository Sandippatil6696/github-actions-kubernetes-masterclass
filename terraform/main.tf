data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

module "vpc" {
  source = "./modules/vpc"

  name             = local.cluster_name
  vpc_cidr         = local.vpc_cidr[local.env]
  azs              = slice(data.aws_availability_zones.available.names, 0, 3)
  public_subnets   = local.public_subnets[local.env]
  private_subnets  = local.private_subnets[local.env]
  intra_subnets    = local.intra_subnets[local.env]
  tags             = local.tags
}

module "eks" {
  source = "./modules/eks"

  cluster_name      = local.cluster_name
  cluster_version   = var.cluster_version

  vpc_id            = module.vpc.vpc_id
  private_subnets   = module.vpc.private_subnets
  intra_subnets     = module.vpc.intra_subnets

  node_instance_type = var.node_instance_type
  node_desired_count = var.node_desired_count
  node_min_count     = var.node_min_count
  node_max_count     = var.node_max_count

  tags = local.tags
}



module "argocd" {
  source = "./modules/argocd"

  namespace    = "argocd"
  service_type = "LoadBalancer"

  eks_dependency = module.eks
}