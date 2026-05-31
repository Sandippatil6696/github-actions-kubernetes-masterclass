resource "helm_release" "csi_secrets_store" {
  
  name = "secrets-store-csi-driver"
  repository = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  chart = "secrets-store-csi-driver"
  namespace        = "kube-system"
  
  set {
    name  = "syncSecret.enabled"
    value = "true"
  }

  set {
    name  = "enableSecretRotation"
    value = "true"
  }

  set {
  name  = "rbac.install"
  value = "true"
}

}

resource "helm_release" "secrets_csi_driver_aws_provider" {
  name = "secrets-store-csi-driver-provider-aws"

  repository = "https://aws.github.io/secrets-store-csi-driver-provider-aws"
  chart      = "secrets-store-csi-driver-provider-aws"
  namespace  = "kube-system"

  depends_on = [
    helm_release.csi_secrets_store
  ]  
}

resource "aws_iam_policy" "myapp_secrets_policy" {
  name = "${var.environment}-myapp-secrets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = "*" 
      }
    ]
  })
}

# IRSA ROLE
module "secrets_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 5.0"

  create_role = true

  role_name = "${var.environment}-secrets-role"

  provider_url = var.oidc_provider

  role_policy_arns = [
    aws_iam_policy.myapp_secrets_policy.arn,
  ]

  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.namespace}:secrets-sa"]
}
