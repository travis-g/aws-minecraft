resource "aws_security_group" "sg" {
  count       = "${var.count}"
  name        = "minecraft"
  description = "Security group for access to Minecraft servers"
  vpc_id      = "${var.vpc_id}"

  # Allows ingress Minecraft traffic
  ingress {
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
  }

  # Allow ingress ping/ICMP traffic
  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
