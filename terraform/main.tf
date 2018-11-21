terraform {
  backend "s3" {
    bucket  = "tjg-terraform-state"
    region  = "us-east-1"
    encrypt = true
    acl     = "private"
    key     = "minecraft-btw-tfstate"
  }
}

provider "aws" {
  region = "${var.aws_region}"
}

module "minecraft_btw" {
  source        = "module"
  aws_region    = "${var.aws_region}"
  vpc_id        = "${var.vpc_id}"
  subnet_id     = "${var.subnet_id}"
  ami_id        = "${var.ami_id}"
  instance_type = "${var.instance_type}"

  s3_bucket = "${var.s3_bucket_name}"

  use_spot_instances = "${var.use_spot_instances}"
  spot_price         = "${var.spot_price}"

  project_name   = "${var.project_name}"
  component_name = "${var.component_name}"

  providers = {
    aws = "aws"
  }
}
