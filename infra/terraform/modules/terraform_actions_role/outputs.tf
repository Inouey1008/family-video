output "arn" {
  description = "ロールの ARN"
  value       = aws_iam_role.this.arn
}

output "name" {
  description = "ロール名"
  value       = aws_iam_role.this.name
}
