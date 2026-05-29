output "myapp_secrets_role_arn" {
  description = "myapp_secrets_role_arn"
  value       = module.secrets_irsa_role.iam_role_arn
}