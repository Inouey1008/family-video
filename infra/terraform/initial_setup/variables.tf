variable "aws_account_id" {
  description = "デプロイ先の AWS アカウント ID (12 桁)"
  type        = string
}

variable "state_bucket_name" {
  description = "Terraform の state を置く S3 バケット名 (グローバルで一意。アカウント ID は含めない)"
  type        = string
}

variable "github_owner" {
  description = "GitHub のリポジトリの owner 名"
  type        = string
}

variable "github_owner_id" {
  description = "GitHub の owner の数値 ID (OIDC の sub に含める)"
  type        = string
}

variable "github_repo" {
  description = "GitHub のリポジトリ名"
  type        = string
}

variable "github_repo_id" {
  description = "GitHub のリポジトリの数値 ID (OIDC の sub に含める)"
  type        = string
}

variable "monthly_budget_usd" {
  description = "月額予算の上限 (USD)"
  type        = number
}

variable "budget_notification_emails" {
  description = "予算の通知先メールアドレス"
  type        = list(string)
  sensitive   = true
}
