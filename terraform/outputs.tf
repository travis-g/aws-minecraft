output "s3_bucket_name" {
  value = "${var.s3_bucket_name}"
}

output "elastic_ip_address" {
  value = "${module.minecraft_btw.elastic_ip_address}"
}

output "instance_ssh" {
  value = "ssh -i ~/.ssh/${module.minecraft_btw.key_name}.pem ec2-user@${module.minecraft_btw.elastic_ip_address}"
}
