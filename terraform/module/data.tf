data "aws_ami" "minecraft" {
  most_recent = true

  filter {
    name   = "tag:mc_version"
    values = []
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "template_file" "config" {
  template = "${file("${path.module}/templates/userdata.yaml")}"

  vars {}
}
