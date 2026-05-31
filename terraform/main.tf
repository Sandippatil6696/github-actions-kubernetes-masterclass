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
  service_type = "ClusterIP"
  eks_dependency = module.eks
}


module "envoy_gateway" {

  source = "./modules/envoy-gateway"

  release_name = "eg-${local.env}"

  namespace = "envoy-gateway-system"
  service_type = "LoadBalancer"
  gateway_api_version   = "v1.2.1"
  envoy_gateway_version = "v1.2.6"
  cluster_name = local.cluster_name
  aws_region = var.aws_region

  depends_on = [module.eks]
}

module "cert_manager" {
  source = "./modules/cert-manager"
  release_name = "cert-manager"
  namespace    = "cert-manager"
  chart_version = var.cert_manager_version
  depends_on = [module.eks]
}

module "monitoring" {
  source = "./modules/monitoring"
  namespace            = "monitoring"
  grafana_service_type = "ClusterIP"
  depends_on = [module.eks]
}

module "secret_store_csi_driver" {
  source = "./modules/secret-store-csi-driver"
  namespace = var.namespace
  oidc_provider = module.eks.oidc_provider
  environment = local.env
}