resource "aws_s3_bucket" "this" {
  provider = aws.us_east_1
  bucket   = var.s3_bucket_name
  tags     = local.default_tags_s3
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  provider = aws.us_east_1
  bucket   = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.s3_encryption_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "this" {
  provider = aws.us_east_1
  bucket   = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.s3_versioning ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  count                   = var.s3_public_access_block ? 1 : 0
  provider                = aws.us_east_1
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
