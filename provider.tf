provider "aws" {
  version = "~> 1.42"
  region = "${var.aws_default_region}"
  allowed_account_ids = [
    "${var.aws_account_id}",
  ]
}
