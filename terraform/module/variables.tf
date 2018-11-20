# --- global AWS variables

variable "aws_region" {
  description = "AWS region in which to provision"
}

variable "aws_profile" {
  description = "AWS IAM profile to use when provisioning"
}

variable "vpc_id" {
  description = "ID of the AWS VPC to provision inside"
}

# --- Metadata

variable "project_name" {
  description = "Slugified name of the infrastructure's overall project"
}
variable "component_name" {
  description = "Slugified name of what this code creates"
}

# --- EC2 Variables

variable "instance_type" {
  description = "EC2 instance type to use"
  default = "t2.micro"
}

variable "instance_profile" {
  description = "EC2 IAM instance profile"
}

variable "spot_price" {
  description = "Bid for spot instances"
}

variable "s3_bucket" {
  description = "S3 bucket where related files will be exported"
}
