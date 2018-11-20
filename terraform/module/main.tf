provider "aws" {}

resource "aws_launch_configuration" "lc" {
  name_prefix   = "${var.project_name}-${var.component_name}"
  image_id      = "${data.aws_ami.minecraft.id}"
  instance_type = "${var.instance_type}"

  spot_price = "${var.spot_price}"

  # TODO
  # security_groups = []

  iam_instance_profile = "${var.instance_profile}"

  user_data = "${data.template_file.config.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "instances" {
  name = "${var.project_name}-${var.component_name}"
  launch_configuration = "${aws_launch_configuration.lc.name}"

  min_size = 0
  max_size = 1

  tags {
    Project   = "${var.project_name}"
    Component = "${var.component_name}"
    Name      = "${var.project_name}-${var.component_name}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# --- Autoscaling schedules (UTC)

resource "aws_autoscaling_schedule" "weeknights_on" {
  # 5PM EST Monday-Friday
  recurrence = "0 22 * * 1-5"

  scheduled_action_name = "weeknight-scale-up"
  min_size = 0
  max_size = 1
  desired_capacity = 1
  autoscaling_group_name = "${aws_cloudformation_stack.ag.outputs["AsgName"]}"
}

resource "aws_autoscaling_schedule" "weekdays_off" {
  # 1AM EST Monday-Friday
  recurrence = "0 6 * * 1-5"

  scheduled_action_name = "weekday-scale-down"
  min_size = 0
  max_size = 1
  desired_capacity = 0
  autoscaling_group_name = "${aws_cloudformation_stack.ag.outputs["AsgName"]}"
}

resource "aws_autoscaling_schedule" "weekends_on" {
  # 5PM EST Friday-Sunday
  recurrence = "0 22 * * 5,6,0"

  scheduled_action_name = "weekend-scale-up"
  min_size = 0
  max_size = 1
  desired_capacity = 1
  autoscaling_group_name = "${aws_cloudformation_stack.ag.outputs["AsgName"]}"
}
