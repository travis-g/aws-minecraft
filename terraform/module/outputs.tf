output "s3_bucket_name" {
  value = "${var.s3_bucket_name}"
}

output "dns_name" {
  value = "${aws_lb.load_balancer.count>0?join(",",aws_lb.load_balancer.*.dns_name):"NONE"}"
}
