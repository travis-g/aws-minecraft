resource "aws_cloudwatch_log_group" "server_logs" {
  name              = "${var.unique_prefix}_${var.server_name}_logs"
  retention_in_days = "${var.log_retention}"

  tags {
    "Project"   = "${var.project_name}"
    "Component" = "${var.component_name}"
    "Name"      = "${var.project_name}-${var.component_name}"
  }
}
