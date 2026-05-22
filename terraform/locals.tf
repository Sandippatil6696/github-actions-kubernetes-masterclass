locals {
  env = terraform.workspace

  cluster_name = "skillpulse-${local.env}-eks"

  tags = {
    Project     = "Skillpulse"
    Environment = local.env
    ManagedBy   = "Terraform"
  }

  vpc_cidr = {
    dev   = "10.0.0.0/16"
    stage = "10.1.0.0/16"
    prod  = "10.2.0.0/16"
  }

  public_subnets = {
    dev   = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    stage = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
    prod  = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]
  }

  private_subnets = {
    dev   = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
    stage = ["10.1.4.0/24", "10.1.5.0/24", "10.1.6.0/24"]
    prod  = ["10.2.4.0/24", "10.2.5.0/24", "10.2.6.0/24"]
  }

  intra_subnets = {
    dev   = ["10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24"]
    stage = ["10.1.7.0/24", "10.1.8.0/24", "10.1.9.0/24"]
    prod  = ["10.2.7.0/24", "10.2.8.0/24", "10.2.9.0/24"]
  }
}