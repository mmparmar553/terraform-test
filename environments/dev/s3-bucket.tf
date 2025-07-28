# S3 Bucket for Development Environment
# This demonstrates real AWS infrastructure deployment with Atlantis

# Random ID for globally unique bucket naming
resource "random_id" "bucket_suffix" {
  byte_length = 8
}

# S3 Bucket with security best practices
resource "aws_s3_bucket" "app_storage" {
  bucket = "${var.environment}-atlantis-demo-${random_id.bucket_suffix.hex}"
  
  tags = {
    Name        = "${var.environment}-app-storage"
    Environment = var.environment
    Purpose     = "application-storage"
    ManagedBy   = "terraform"
    Project     = "atlantis-demo"
    Owner       = "sre-team"
  }
}

# S3 Bucket Versioning (Data Protection)
resource "aws_s3_bucket_versioning" "app_storage" {
  bucket = aws_s3_bucket.app_storage.id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 Bucket Server Side Encryption (Security Requirement)
resource "aws_s3_bucket_server_side_encryption_configuration" "app_storage" {
  bucket = aws_s3_bucket.app_storage.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# S3 Bucket Public Access Block (Critical Security Control)
resource "aws_s3_bucket_public_access_block" "app_storage" {
  bucket = aws_s3_bucket.app_storage.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 Bucket Lifecycle Configuration (Cost Optimization)
resource "aws_s3_bucket_lifecycle_configuration" "app_storage" {
  bucket = aws_s3_bucket.app_storage.id

  rule {
    id     = "transition_to_ia"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    expiration {
      days = 365
    }
  }

  rule {
    id     = "delete_incomplete_multipart_uploads"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

# S3 Bucket Notification (Optional - for monitoring)
resource "aws_s3_bucket_notification" "app_storage" {
  bucket = aws_s3_bucket.app_storage.id

  # This would typically connect to SNS/SQS/Lambda
  # For demo purposes, we'll keep it simple
}

# S3 Bucket Policy (Least Privilege Access)
resource "aws_s3_bucket_policy" "app_storage" {
  bucket = aws_s3_bucket.app_storage.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "DenyInsecureConnections"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.app_storage.arn,
          "${aws_s3_bucket.app_storage.arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })
}
