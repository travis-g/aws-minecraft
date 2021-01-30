# --- global AWS variables

variable "region" {
  description = "AWS region in which to provision"
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "ID of the AWS VPC to provision inside"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Target subnets. Desired spot instance type must be available in the subnets AZs"
}

variable "availability_zones" {
  type        = list(string)
  description = "Acceptable availability zones"
}

# --- Metadata

variable "unique_prefix" {
  description = "Unique prefix given to all resources"
}

variable "project_name" {
  description = "Slugified name of the infrastructure's overall project"
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
}

variable "instance_type" {
  description = "EC2 instance type to use"
  default     = "t2.micro"
}

variable "ram_allocation" {
  description = "RAM allocation, in gigabytes, for the Java server process"
  default     = 3
}

variable "use_spot_instances" {
  description = "Option to use Spot instances"
  default     = false
}

variable "spot_price" {
  description = "Maximum bid for spot instances"
}

variable "manual_scale_up" {
  description = "Boolean to scale the cluster manually by setting desired instance count"
  default     = false
}

variable "scale_down" {
  description = "Boolean to scale the cluster down during off hours"
  default     = true
}

variable "s3_bucket_name" {
  description = "S3 bucket where related files will be exported"
}

variable "key_name" {
  description = "Name of the SSH key to use"
}

variable "server_name" {
  description = "Friendly name of the server to use when storing state"
}

# -- CloudWatch Variables

variable "log_retention" {
  description = "Number of days after which logs will expire"
  default     = 0
}
