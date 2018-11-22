aws_region = "us-east-1"

vpc_id = "vpc-68ad0b12"

project_name = "minecraft"

component_name = "cluster"

s3_bucket_name = "minecraft-btw"

// instance_type= "m3.large"
instance_type = "t2.micro"

spot_price = 0.032

role_name = "minecraft-server"

unique_prefix = "minecraft"

subnet_ids = [
  "subnet-79a4fe33",
]

key_name = "minecraft-ssh"

tag_project = "minecraft-cluster"
