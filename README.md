# aws-minecraft

## Goals

- [x] Full infrastructure-as-code configuration,
- [x] An auto-starting Minecraft server,
- [x] S3 storage to persist the server,
- [x] Auto-archive backups to S3,
- [x] Resilient hosting capability on [spot instances](https://aws.amazon.com/ec2/spot/)
  - Uses [`terminationd`](https://github.com/travis-g/terminationd)

## Stretch Goals

- [ ] Multiple servers on a single instance,
- [ ] Cleaner variable usage

## Configuration

- Create the S3 bucket in your AWS account.
- Pre-seed S3 with the desired server JAR and any configuration files:

  ```sh
  aws s3 cp server.jar s3://${var.s3_bucket}/server/server.jar
  aws s3 cp ops.txt    s3://${var.s3_bucket}/server/ops.txt
  # ...
  ```
  
  - Server `.jar`s for MC versions can be found here: https://mcversions.net/
  - Any server config files such as `whitelist.txt` can also be placed under the server's state folder (`server` in the above example)
- Populate the `environment.auto.tfvars` with VPC IDs, subnet IDs, bucket names, etc. Check the `variables.tf` file for descriptions and defaults.

## Notes

- If you chose to use spot instances (depending on the desired instance size) it may be cheaper to run the server 24/7: unused Elastic IP addresses cost 1¢/hr.
