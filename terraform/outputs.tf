output "s3_bucket_name" {
  value = "${var.s3_bucket_name}"
}

output "elastic_ip_address" {
  value = "${module.minecraft_btw.elastic_ip_address}"
}
