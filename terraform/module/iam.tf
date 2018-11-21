# --- IAM policy resources

# -- Generic STS AssumeRole policy
resource "aws_iam_role" "instance_iam_role" {
  name = "${var.role_name}"
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

resource "aws_iam_instance_profile" "s3_profile" {
  name = "${var.role_name}_s3_profile"
  role = "${aws_iam_role.instance_iam_role.name}"
}

resource "aws_iam_policy" "s3_iam_policy" {
  name   = "${var.role_name}_policy"
  path   = "/"
  policy = "${data.aws_iam_policy_document.s3_policy_doc.json}"
}

resource "aws_iam_policy_attachment" "bucket_rw_attachment" {
  name       = "bucket_rw_attachment"
  roles      = ["${aws_iam_role.instance_iam_role.name}"]
  policy_arn = "${aws_iam_policy.minecraft_s3_bucket_rw.arn}"
}

data "aws_iam_policy_document" "s3_policy_doc" {
  statement {
    sid = "ListS3"

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${var.s3_bucket_name}",
    ]
  }

  statement {
    sid = "ReadWriteBucket"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]

    resources = [
      "arn:aws:s3:::${var.s3_bucket_name}/*",
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
