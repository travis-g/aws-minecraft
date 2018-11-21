# --- global AWS variables

variable "aws_region" {
  description = "AWS region in which to provision"
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "ID of the AWS VPC to provision inside"
}

variable "subnet_id" {
  description = "Target subnet. Desired spot instance type must be available in the subnet's AZ"
}

# --- Metadata

variable "project_name" {
  description = "Slugified name of the infrastructure's overall project"
}

variable "component_name" {
  description = "Slugified name of what this code creates"
}

# --- EC2 Variables

variable "ami_id" {
  description = "ID of AMI to use for instances"
}

variable "instance_type" {
  description = "EC2 instance type to use"
  default     = "t2.micro"
}

variable "use_spot_instances" {
  description = "Option to use Spot instances"
  default     = false
}

variable "spot_price" {
  description = "Maximum bid for spot instances"
}

variable "s3_bucket" {
  description = "S3 bucket where related files will be exported"
}
