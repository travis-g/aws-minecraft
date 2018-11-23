provider "aws" {
  region = "${var.region}"
}

resource "aws_launch_configuration" "lc" {
  name_prefix   = "${var.project_name}-${var.component_name}"
  image_id      = "${data.aws_ami.minecraft.id}"
  instance_type = "${var.instance_type}"

  iam_instance_profile = "${aws_iam_instance_profile.s3_profile.name}"

  // spot_price = "${var.spot_price}"

  associate_public_ip_address = true
  security_groups = [
    "sg-03a223cdddca7909d",
    "sg-0d0507ed4257e1fb9",
  ]
  key_name  = "${var.key_name}"
  user_data = "${data.template_file.minecraftd_init.rendered}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "server_cluster" {
  name                 = "${var.project_name}-${var.component_name}"
  launch_configuration = "${aws_launch_configuration.lc.name}"

  vpc_zone_identifier = ["${var.subnet_ids}"]

  // load_balancers      = ["${aws_lb.load_balancer.name}"]
  target_group_arns = ["${aws_lb_target_group.servers.arn}"]

  desired_capacity = 1
  min_size         = 0
  max_size         = 1
  default_cooldown = 60

  tag {
    key                 = "Project"
    value               = "${var.project_name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Component"
    value               = "${var.component_name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.component_name}"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# --- Autoscaling schedules (UTC)

resource "aws_autoscaling_schedule" "weeknights_on" {
  # 5PM EST Monday-Friday
  recurrence = "0 22 * * 1-5"

  scheduled_action_name  = "weeknight-scale-in"
  min_size               = 0
  max_size               = 1
  desired_capacity       = 1
  autoscaling_group_name = "${aws_autoscaling_group.server_cluster.name}"
}

resource "aws_autoscaling_schedule" "weekdays_off" {
  # 1AM EST Monday-Friday
  recurrence = "0 6 * * 1-5"

  scheduled_action_name  = "weekday-scale-in"
  min_size               = 0
  max_size               = 1
  desired_capacity       = 0
  autoscaling_group_name = "${aws_autoscaling_group.server_cluster.name}"
}

resource "aws_autoscaling_schedule" "weekends_on" {
  # 6PM EST Friday-Sunday
  recurrence = "0 23 * * 5,6,0"

  scheduled_action_name  = "weekend-scale-out"
  min_size               = 0
  max_size               = 1
  desired_capacity       = 1
  autoscaling_group_name = "${aws_autoscaling_group.server_cluster.name}"
}

resource "aws_lb" "load_balancer" {
  name               = "${var.project_name}-nlb"
  load_balancer_type = "network"

  internal = false

  enable_cross_zone_load_balancing = true

  subnets = ["${var.subnet_ids}"]
}

resource "aws_lb_listener" "minecraft" {
  load_balancer_arn = "${aws_lb.load_balancer.arn}"
  port              = "${var.inbound_port}"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.servers.arn}"
  }
}

resource "aws_lb_target_group" "servers" {
  name     = "${var.project_name}-servers"
  port     = "${var.inbound_port}"
  protocol = "TCP"
  vpc_id   = "${var.vpc_id}"
}
