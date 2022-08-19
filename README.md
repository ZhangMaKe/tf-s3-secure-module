# tf-s3-secure-bucket-module

Terraform module that creates an S3 bucket with:
* KMS Encryption using a CMK supplied to the module in its input vars
* Server access logging enabled and logged to a separate S3 bucket (provided as input variable)
* A bucket policy that denies non-SS/TLS requests

## Variables
The following variables are required:

* "bucket_name" - the name of the bucket (must be globally unique)
* "versioning_enabled" (optional) - a variable to set the versioning configuration of the bucket, must be either "Enabled", "Disabled", or "Suspended". If no value is provided, versioning is Enabled.
* "logging_bucket" - the name of the S3 bucket that server access logs will be written to
* "kms_key_arn" - the arn of the KMS CMK that will be used to encrypt/decrypt objects in the bucket

## Usage Example
The following will create an S3 bucket named 'mybucketname-123-xyz-dsgdgd'.  Its access logs will be stored in 'my-logging-bucket'. Versioning will be disabled. And objects in the bucket will be encrypted using the kms key provided.
```
module "s3_bucket_module" {
    source = "git::https://github.com/myrepo.git?ref=v1.0.1

    bucket_name = "mybucketname-123-xyz-dsgdgd"
    versioning_enabled = "Disabled"
    logging_bucket = "my-logging-bucket"
    kms_key_arn = arn:aws:eu-west-1:1234567890:key/sdggdagn54as-fasaf-sdgs3r
}
```
