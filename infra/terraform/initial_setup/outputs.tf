output "state_bucket_name" {
  description = "state を置く S3 バケット名"
  value       = module.terraform_backend.bucket_name
}

output "role_arns" {
  description = "Terraform 用ロールの ARN"
  value = {
    for key, role in module.terraform_actions_role : key => role.arn
  }
  sensitive = true
}

output "oidc_provider_arn" {
  description = "GitHub Actions の OIDC プロバイダーの ARN"
  value       = module.github_actions_oidc_provider.arn
  sensitive   = true
}
