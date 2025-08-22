output "primary_bucket" {
  value = aws_s3_bucket.primary.bucket
}

output "backup_bucket" {
  value = aws_s3_bucket.backup.bucket
}

output "dynamodb_table" {
  value = aws_dynamodb_table.terraform_locks.name
}
