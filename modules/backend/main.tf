# Create a DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_state_lock" {
  name         = "terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

# Create the main S3 bucket for the state file
resource "aws_s3_bucket" "main_bucket" {
  bucket = "todelete-main-unique-suffix"  # Change to a unique bucket name
}

# Create the backup S3 bucket for the state file
resource "aws_s3_bucket" "backup_bucket" {
  bucket = "todelete-backup-unique-suffix"  # Change to a unique bucket name
}

# Enable versioning for the main S3 bucket
resource "aws_s3_bucket_versioning" "main_bucket_versioning" {
  bucket = aws_s3_bucket.main_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable versioning for the backup S3 bucket
resource "aws_s3_bucket_versioning" "backup_bucket_versioning" {
  bucket = aws_s3_bucket.backup_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Create an IAM role for S3 replication
resource "aws_iam_role" "replication_role" {
  name = "s3-replication-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Principal = {
        Service = "s3.amazonaws.com"
      }
      Effect    = "Allow"
      Sid       = ""
    }]
  })
}

# Attach a policy to the replication role
resource "aws_iam_role_policy" "replication_policy" {
  name   = "s3-replication-policy"
  role   = aws_iam_role.replication_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:GetObjectVersion",
          "s3:GetObjectVersionAcl"
        ]
        Resource = [
          "${aws_s3_bucket.main_bucket.arn}/*",
          "${aws_s3_bucket.backup_bucket.arn}/*"
        ]
      }
    ]
  })
}

# Create replication configuration for the main S3 bucket
resource "aws_s3_bucket_replication_configuration" "replication" {
  bucket = aws_s3_bucket.main_bucket.id

  role = aws_iam_role.replication_role.arn

  rule {
    id     = "replication-rule"
    status = "Enabled"

    destination {
      bucket = aws_s3_bucket.backup_bucket.arn
      storage_class = "STANDARD"
    }
  }
}