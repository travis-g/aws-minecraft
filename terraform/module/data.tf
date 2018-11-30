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

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  // amazon-owned
  owners = ["137112412989"]
}

# --- cloud-init config
data "template_file" "minecraftd_init" {
  template = "${file("${path.module}/templates/user_data.yaml")}"

  vars {
    region         = "${var.region}"
    eip_alloc      = "${aws_eip.server_address.id}"
    s3_bucket_name = "${var.s3_bucket_name}"
  }
}
