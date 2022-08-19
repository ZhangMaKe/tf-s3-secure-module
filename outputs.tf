output "bucket_name" {
  value       = aws_s3_bucket.bucket.id
  description = "The name of the S3 created bucket"
}

output "bucket_arn" {
  value       = aws_s3_bucket.bucket.arn
  description = "the arn of the created bucket"
}