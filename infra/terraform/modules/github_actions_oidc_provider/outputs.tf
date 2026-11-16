output "arn" {
  description = "OIDC プロバイダーの ARN"
  value       = aws_iam_openid_connect_provider.this.arn
}
