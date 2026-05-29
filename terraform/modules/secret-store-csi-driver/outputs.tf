output "myapp_secrets_role_arn" {
  description = "myapp_secrets_role_arn"
  value       = aws_iam_policy.myapp_secrets_policy.arn
}