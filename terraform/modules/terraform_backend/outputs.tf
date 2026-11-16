output "bucket_name" {
  description = "バケット名"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "バケットの ARN"
  value       = aws_s3_bucket.this.arn
}
