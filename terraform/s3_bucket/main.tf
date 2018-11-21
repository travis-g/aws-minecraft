provider "aws" {
  region = "${var.aws_region}"
}

data "aws_region" "current" {}

data "aws_iam_account_alias" "current" {}

data "aws_iam_policy_document" "s3" {
  statement {
    sid    = "Enforce HTTPS connections"
    effect = "Deny"

    actions = [
      "s3:*",
    ]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = ["arn:aws:s3:::${format("%.63s", var.bucket_name)}/*"]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"

      values = ["false"]
    }
  }
}

esource "aws_s3_bucket" "bucket" {
  bucket = "${format("%.63s", var.bucket_name)}"
  acl    = "private"
  policy = "${data.aws_iam_policy_document.s3.json}"

  versioning {
    enabled = true
  }

  tags {
    Name      = "${format("%.63s", var.bucket_name)}"
    Project   = "${var.tag_project}"
    Component = "${var.tag_component}"
  }

  logging {
    # target_bucket = "${data.aws_iam_account_alias.current.account_alias}-${data.aws_region.current.name}-inf-s3bucketlog"
    target_prefix = "${format("%.63s", var.bucket_name)}/log/"
  }
}
