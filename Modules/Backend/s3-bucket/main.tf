provider "aws" {
  region = var.primary_region
}

provider "aws" {
  alias  = "secondary"
  region = var.backup_region
}

resource "aws_s3_bucket" "primary" {
  bucket = var.primary_bucket_name
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = merge(
    {
      Name = "terraform-primary-state"
    },
    var.tags
  )
}

resource "aws_s3_bucket" "backup" {
  provider = aws.secondary

  bucket = var.backup_bucket_name
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = merge(
    {
      Name = "terraform-backup-state"
    },
    var.tags
  )
}

# DynamoDB Table for state locking (in primary region)
resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = merge(
    {
      Name = "terraform-locks"
    },
    var.tags
  )
}
