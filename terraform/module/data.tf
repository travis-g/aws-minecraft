# --- Templates and seed data

data "aws_ami" "minecraft" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  // amazon-owned
  owners = ["137112412989"]
}

data "template_file" "minecraftd_init" {
  template = "${file("${path.module}/templates/user_data.yaml")}"

  vars {
    s3_bucket = "${var.s3_bucket_name}"

    // key_id = "${var.key_id}"
  }
}
