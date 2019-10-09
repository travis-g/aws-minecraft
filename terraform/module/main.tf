provider "aws" {
  region = "${var.region}"
}

# --- Elastic IP to use instead of an ELB's DNS address
resource "aws_eip" "server_address" {
  vpc = true
}

# --- Autoscaling Server Cluster

resource "aws_autoscaling_group" "server_cluster" {
  name                 = "${var.project_name}-${var.component_name}"
  launch_configuration = "${aws_launch_configuration.lc.name}"
  default_cooldown     = 60

  vpc_zone_identifier = ["${var.subnet_ids}"]

  desired_capacity = 1
  min_size         = 0
  max_size         = 1

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

# --- Autoscaling schedules (UTC)

// resource "aws_autoscaling_schedule" "nights_on" {
//   scheduled_action_name = "weeknight-scale-out"

//   # 5PM EST every night
//   recurrence       = "0 22 * * *"
//   // desired_capacity = 0

//   min_size               = 0
//   max_size               = 1
//   autoscaling_group_name = "${aws_autoscaling_group.server_cluster.name}"
// }

resource "aws_autoscaling_schedule" "weekdays_off" {
  scheduled_action_name = "weekday-scale-in"

  # 12AM EST Monday-Friday
  recurrence       = "0 5 * * *"
  desired_capacity = "${var.scale_down ? 0 : 1}"

  min_size               = 0
  max_size               = 1
  autoscaling_group_name = "${aws_autoscaling_group.server_cluster.name}"
}
