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
  template = templatefile("${path.module}/templates/user_data.yaml", {
    region         = var.region
    eip_alloc      = aws_eip.server_address.id
    s3_bucket_name = var.s3_bucket_name
    server_name    = var.server_name
    ram_alloc      = var.ram_allocation
    use_run_script = var.use_run_script
  })
}
