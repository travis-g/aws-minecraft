variable "aws_region" {
  description = "The AWS Region we are deploying infrastructure and applications"
}

variable "bucket_name" {
  description = "Partial name of the s3 bucket. Will be used in addition to other environment based data elements"
  default     = ""
}
