# Output the DynamoDB table and S3 bucket ARNs
output "dynamodb_table_arn" {
  value = aws_dynamodb_table.terraform_state_lock.arn
}

output "main_bucket_arn" {
  value = aws_s3_bucket.main_bucket.arn
}

output "backup_bucket_arn" {
  value = aws_s3_bucket.backup_bucket.arn
}