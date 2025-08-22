variable "primary_region" {
  type        = string
  description = "AWS region for the primary S3 bucket and DynamoDB table"
  default     = "us-east-1"
}

variable "backup_region" {
  type        = string
  description = "AWS region for the backup S3 bucket (replication target)"
  default     = "us-west-2"
}

variable "primary_bucket_name" {
  type        = string
  description = "Name of the primary S3 bucket for Terraform state storage"
  default     = "my-terraform-state-primary"
}

variable "backup_bucket_name" {
  type        = string
  description = "Name of the backup S3 bucket for replication"
  default     = "my-terraform-state-backup"
}

variable "dynamodb_table_name" {
  type        = string
  description = "Name of the DynamoDB table for Terraform state locking"
  default     = "terraform-state-locks"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default = {
    Environment = "dev"
    Project     = "terraform-backend"
    Owner       = "DevOpsTeam"
  }
}
