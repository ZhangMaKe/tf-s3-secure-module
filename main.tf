
/*
 A resource that defines the S3 bucket with a name assigned using an input variable
*/
resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  #checkov:skip=CKV_AWS_144:Cross-Region Replication not required by default
}

/*
 A resource that defines the versioning status of the bucket
*/
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.bucket.id

  versioning_configuration {
    status = var.versioning_enabled
  }
}

/*
 A resource that defines the server-side encryption settings of the bucket.
 The bucket must be encrypted using a customer CMK, the arn of which is 
 provided as an input variable
*/
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption_configuration" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

/*
 A resource that defines where access logs for the bucket should be stored.
 Uses the bucket name as the prefix.
*/
resource "aws_s3_bucket_logging" "bucket_logging" {
  bucket = aws_s3_bucket.bucket.id

  target_prefix = var.bucket_name
  target_bucket = var.logging_bucket
}

/*
 A resource that blocks all public access to the bucket
*/
resource "aws_s3_bucket_public_access_block" "bucket_public_access_block" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

/*
 A basic bucket policy that denies all non-secure (http) requests to the bucket
*/
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.id

  policy = jsonencode({
    "Statement" : [
      {
        "Action" : "s3:*",
        "Effect" : "Deny",
        "Resource" : [
          join("", ["arn:aws:s3:::", var.bucket_name, "/*"])
        ],
        "Principal" : "*",
        "Condition" : {
          "Bool" : {
            "aws:SecureTransport" : "false"
          }
        }
      }
    ]
  })
}