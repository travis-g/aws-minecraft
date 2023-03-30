aws_region = "us-east-1"

vpc_id = "vpc-68ad0b12"

project_name = "minecraft"

component_name = "cluster"

s3_bucket_name = "minecraft-btw"

// instance_type = "t2.micro"
// instance_type = "m3.large"
# instance_type = "m5a.large" # 2CPU, 8GB
instance_type = "m5a.xlarge" # 4CPU, 16GB
# instance_type = "m5a.2xlarge"
// instance_type = "t3.medium"

ram_allocation = 6

use_elastic_ip = false

spot_price = ""

scale_down = true

role_name = "minecraft-server"

unique_prefix = "minecraft"

subnet_ids = [
  "subnet-79a4fe33",
  "subnet-607aed3c",
]

key_name = "minecraft-ssh"

tag_project = "minecraft-cluster"

server_name = "wallcraft"

log_retention = 3
