provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_launch_configuration" "lc" {
  name_prefix   = "${var.project_name}-${var.component_name}"
  image_id      = "${data.aws_ami.minecraft.id}"
  instance_type = "${var.instance_type}"

  iam_instance_profile = "${aws_iam_instance_profile.server_profile.name}"

  // spot_price = "${var.spot_price}"

  associate_public_ip_address = true
  security_groups = [
    "sg-03a223cdddca7909d",
    "sg-0d0507ed4257e1fb9",
  ]
  key_name  = "minecraft-ssh"

  user_data = "${data.template_file.init.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_subnet" "selected" {
  // id = "${var.subnet_id}"
  id = "subnet-119ad61e"
}

resource "aws_autoscaling_group" "servers" {
  name                 = "${var.project_name}-${var.component_name}"
  launch_configuration = "${aws_launch_configuration.lc.name}"

  vpc_zone_identifier = ["${var.subnet_id}"]

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

  scheduled_action_name  = "weeknight-scale-up"
  min_size               = 0
  max_size               = 1
  desired_capacity       = 1
  autoscaling_group_name = "${aws_autoscaling_group.servers.name}"
}

resource "aws_autoscaling_schedule" "weekdays_off" {
  # 1AM EST Monday-Friday
  recurrence = "0 6 * * 1-5"

  scheduled_action_name  = "weekday-scale-down"
  min_size               = 0
  max_size               = 1
  desired_capacity       = 0
  autoscaling_group_name = "${aws_autoscaling_group.servers.name}"
}

resource "aws_autoscaling_schedule" "weekends_on" {
  # 5PM EST Friday-Sunday
  recurrence = "0 22 * * 5,6,0"

  scheduled_action_name  = "weekend-scale-up"
  min_size               = 0
  max_size               = 1
  desired_capacity       = 1
  autoscaling_group_name = "${aws_autoscaling_group.servers.name}"
}
