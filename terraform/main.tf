# terraform {
#   backend "s3" {
#     bucket  = "aws-minecraft-btw-terraform-state"
#     region  = "us-east-1"
#     encrypt = true
#     acl     = "private"
#     profile = "${var.aws_profile}"
#   }
# }

provider "aws" {
  profile = "${var.aws_profile}"
  region  = "${var.aws_region}"
}

module "minecraft_aws" {
  source           = "module"
  aws_profile      = "${var.aws_profile}"
  aws_region       = "${var.aws_region}"
  vpc_id           = "${var.vpc_id}"
  ami_version      = "${var.ami_version}"
  instance_type    = "${var.instance_type}"
  instance_profile = "${var.instance_profile}"

  spot_price = "${var.spot_price}"

  project_name   = "${var.project_name}"
  component_name = "${var.component_name}"

  providers = {
    aws = "aws"
  }
}
