
# Define provider and region
provider "aws" {
  region = var.region
}

# Input variables
variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

# Input variable for AWS region
variable "region" {
  type = string
}

# Create S3 bucket
resource "aws_s3_bucket" "data_bucket" {
  bucket = var.bucket_name
  acl    = "private"  # Set ACL permissions as needed (private is the default)

  # Server-side encryption configuration
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  # Lifecycle rule to set the storage class
  lifecycle_rule {
    enabled = true  # Enable the lifecycle rule
    id      = "SetStorageClass"

    transition {
      days          = 30  # Move objects to Glacier storage class after 30 days
      storage_class = "GLACIER"
    }
  }
}

# Output the bucket ARN
output "bucket_arn" {
  value = aws_s3_bucket.data_bucket.arn
}

