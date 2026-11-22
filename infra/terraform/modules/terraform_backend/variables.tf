variable "bucket_name" {
  description = "state 用の S3 バケット名"
  type        = string
}

variable "role_arns" {
  description = "Terraform 用ロールの ARN (キーは ci_readonly・dev・prod)"
  type = object({
    ci_readonly = string
    dev         = string
    prod        = string
  })
}
