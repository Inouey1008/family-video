variable "name" {
  description = "ロール名"
  type        = string
}

variable "oidc_provider_arn" {
  description = "GitHub Actions の OIDC プロバイダーの ARN"
  type        = string
}

variable "sub" {
  description = "引き受けを許す OIDC の sub (完全一致)"
  type        = string
}

variable "managed_policy_arns" {
  description = "付ける管理ポリシーの ARN の一覧"
  type        = list(string)
  default     = []
}

variable "inline_policies" {
  description = "インラインポリシーの名前と JSON の対応"
  type        = map(string)
  default     = {}
}
