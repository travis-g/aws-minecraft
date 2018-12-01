# --- global AWS variables

variable "aws_region" {
  description = "AWS region in which to provision"
}

variable "vpc_id" {
  description = "ID of the AWS VPC to provision inside"
}

variable "subnet_ids" {
  type        = "list"
  description = "Target subnets. Desired spot instance type must be available in the subnet's AZ"
}

variable "availability_zones" {
  type        = "list"
  description = "Acceptable availability zones"

  default = [
    "us-east-1a",
  ]
}

# --- Metadata

variable "unique_prefix" {
  description = "Unique prefix given to all resources"
}

variable "project_name" {
  description = "Slugified name of the infrastructure's overarching project"
}

variable "component_name" {
  description = "Slugified name of what this code creates"
}

variable "role_name" {
  description = "Component role name"
}

# --- EC2 Variables

variable "ami_id" {
  description = "ID of AMI to use for instances"
  default     = "ami-009d6802948d06e52"
}

variable "instance_type" {
  description = "EC2 instance type to use"
  default     = "t3.large"
}

variable "use_spot_instances" {
  description = "Option to use Spot instances"
  default     = false
}

variable "spot_price" {
  description = "Bid for spot instances"
}

variable "s3_bucket_name" {
  description = "S3 bucket for storing files"
}

variable "key_name" {
  description = "Key name for SSH access"
}

variable "server_name" {
  description = "Friendly name of the server to use when storing state"
}
