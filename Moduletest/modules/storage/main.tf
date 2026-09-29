# COST: S3 Free Tier = 5 GB storage, 20k GET, 2k PUT per month (12 months).
# An empty bucket costs nothing. Versioning keeps old copies (counts as storage).

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  bucket_name = lower("${var.name}-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}")
}

resource "aws_s3_bucket" "this" {
  bucket        = local.bucket_name
  force_destroy = var.force_destroy
  tags          = merge({ Module = "storage" }, var.tags)
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
