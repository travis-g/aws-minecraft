resource "aws_security_group" "sg" {
  count       = "${var.count}"
  name        = "bastion"
  description = "Security group for SSH access to EC2 instances"
  vpc_id      = "${var.vpc_id}"

  # Allows ingress SSH traffic
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  # Allow ingress ping/ICMP traffic
  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
  }

  # Allow all egress traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
