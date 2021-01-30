terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket  = "tjg-terraform-state"
    region  = "us-east-1"
    encrypt = true
    acl     = "private"
    key     = "minecraft-btw-tfstate"
  }
}

provider "aws" {
  region = var.aws_region
}

module "minecraft_btw" {
  source             = "./module"
  region             = var.aws_region
  vpc_id             = var.vpc_id
  subnet_ids         = var.subnet_ids
  ami_id             = var.ami_id
  instance_type      = var.instance_type
  availability_zones = var.availability_zones
  key_name           = var.key_name

  server_name    = var.server_name
  s3_bucket_name = var.s3_bucket_name
  ram_allocation = var.ram_allocation

  use_spot_instances = var.use_spot_instances
  spot_price         = var.spot_price
  scale_down         = var.scale_down
  log_retention      = var.log_retention

  unique_prefix  = var.unique_prefix
  project_name   = var.project_name
  component_name = var.component_name
  role_name      = var.role_name

  providers = {
    aws = aws
  }
}
