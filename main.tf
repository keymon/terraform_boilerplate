resource "aws_s3_bucket" "example_bucket" {
  bucket = "my-tf-test-bucket-${var.aws_account_id}"
  acl    = "private"
}

output "bucket_arn" {
  value = "${aws_s3_bucket.example_bucket.arn}"
}
