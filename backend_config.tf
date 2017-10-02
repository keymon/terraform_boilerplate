  terraform {
    backend "s3" {
    bucket         = "terraform-tfstate-967847953971"
    key            = "terraform_boilerplate.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform_locks"
  }
}
