# --- IAM policy resources

data "aws_iam_policy_document" "minecraft-s3-bucket-rw_document" {
  statement {
    sid = "ListS3"

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${var.s3_bucket}",
    ]
  }

  statement {
    sid = "ReadWriteBucket"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::${var.s3_bucket}/*",
    ]
  }

  statement {
    sid = "EncryptDecrypt"

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
    ]

    resources = [
      "arn:aws:kms:*:005911068294:key/828d45ea-8bd5-4668-b4b1-bb7014ce2959",
    ]
  }
}

resource "aws_iam_role" "ec2_s3_access_role" {
  name = "s3-role"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ec2.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_policy" "minecraft_s3_bucket_rw" {
  name   = "minecraft-s3-bucket-policy"
  path   = "/"
  policy = "${data.aws_iam_policy_document.minecraft-s3-bucket-rw_document.json}"
}

resource "aws_iam_policy_attachment" "bucket_rw_attachment" {
  name       = "bucket_rw_attachment"
  roles      = ["${aws_iam_role.ec2_s3_access_role.name}"]
  policy_arn = "${aws_iam_policy.minecraft_s3_bucket_rw.arn}"
}

resource "aws_iam_instance_profile" "server_profile" {
  name = "server_profile"
  role = "${aws_iam_role.ec2_s3_access_role.name}"
}
