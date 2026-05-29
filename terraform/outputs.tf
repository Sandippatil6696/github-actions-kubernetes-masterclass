# Cluster
output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_version" {
  description = "Kubernetes version running on the cluster"
  value       = module.eks.cluster_version
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data for cluster authentication"
  value       = module.eks.cluster_certificate_authority_data
  sensitive   = true
}

output "oidc_provider_arn" {
  description = "OIDC provider ARN (for IRSA if needed)"
  value       = module.eks.oidc_provider_arn
}

# Networking
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "Private subnet IDs (worker nodes)"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "Public subnet IDs (load balancers)"
  value       = module.vpc.public_subnets
}

# Quick commands
output "configure_kubectl" {
  description = "Command to configure kubectl"
  value       = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.aws_region}"
}

output "gateway_nlb_ip" {
  description = "Command to get the Envoy Gateway NLB address (use this IP for nip.io hostnames)"
  value       = "kubectl get gateway skillpulse-gateway -n skillpulse -o jsonpath='{.status.addresses[*].value}'"
}

output "argocd_url" {
  description = "ArgoCD URL (replace NLB_IP with output of gateway_nlb_ip)"
  value       = "https://argocd.NLB_IP.nip.io"
}

output "argocd_initial_password" {
  description = "Command to get ArgoCD initial admin password"
  value       = "kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath='{.data.password}' | base64 -d"
}

output "grafana_url" {
  description = "Grafana URL (replace NLB_IP with output of gateway_nlb_ip)"
  value       = "https://grafana.NLB_IP.nip.io"
}

output "grafana_admin_password" {
  description = "Command to get Grafana admin password"
  value       = "kubectl get secret kube-prometheus-grafana -n monitoring -o jsonpath='{.data.admin-password}' | base64 -d; echo"
}

output "app_url" {
  description = "Main application URL (replace NLB_IP with output of gateway_nlb_ip)"
  value       = "https://NLB_IP.nip.io"
}

output "myapp_secrets_role_arn" {
  description = "myapp_secrets_role_arn"
  value       = module.secret_store_csi_driver.myapp_secrets_role_arn
}