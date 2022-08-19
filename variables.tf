variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket, must be globally unique"
}

variable "versioning_enabled" {
  type        = string
  default     = "Enabled"
  description = "Optional variable to denote whether versioning is 'Enabled', 'Disabled', or 'Suspended', default is 'Enabled'"

  validation {
    condition     = contains(["Enabled", "Disabled", "Suspended"], var.versioning_enabled)
    error_message = "Valid values for var: versioning_enabled are (Enabled, Disabled, Suspended)."
  }
}

variable "logging_bucket" {
  type        = string
  description = "The name of the S3 bucket that access logs should be written to"

}

variable "kms_key_arn" {
  type        = string
  description = "the arn of the kms key to be used to perform encrypt/decrypt operations of the bucket's objects"
}