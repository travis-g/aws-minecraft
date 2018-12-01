output "s3_bucket_name" {
  value = "${var.s3_bucket_name}"
}

output "server_name" {
  value = "${var.server_name}"
}

output "elastic_ip_address" {
  value = "${aws_eip.server_address.public_ip}"
}
