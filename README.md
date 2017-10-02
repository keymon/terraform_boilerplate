Terraform boilerplate with AWS S3 backend
-----------------------------------------

Terraform boilerplate configuration to quickly start projects using AWS.

It would:

 - Use docker to wrap the execution of terraform and AWS.
 - Automatically and idempontently configure the
   [backend in S3 and with DynamoDB](https://www.terraform.io/docs/backends/types/s3.html)

To start using it:

 - Clone this repo
 - tweak the `terraform-vars.sh`, `main.tf`, etc...

Once done, run terraform with:

 - The first time init it with: `./run-terraform.sh init`.
   Required to be done in each computer that clones this repo.
 - After: `./run-terraform apply` or any other command.

Gotchas
-------

 - Optional: Change the root directory if different in `terraform-common.sh`
 - The account ID is restricted. You might want to change
   `provider.tf` and/or `terraform-vars.sh`
 - export the variable `DISABLE_DOCKER=1` to use `awscli` and `terraform` directly.

Clean up
--------

To delete the S3 bucket and dynamo db table of the terraform state:

    ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text | tr -d '\r')"
    PROJECT_ROOT=$(git rev-parse --show-toplevel)
    PROJECT_NAME="${PROJECT_ROOT##*/}"
    export AWS_DEFAULT_REGION=eu-west-1

    ./run_awscli s3 ls s3://terraform-tfstate-${ACCOUNT_ID}
    ./run_awscli s3 rm --recursive s3://terraform-tfstate-${ACCOUNT_ID}/${PROJECT_NAME}.tfstate
    ./run_awscli s3api \
        delete-bucket \
        --bucket terraform-tfstate-${ACCOUNT_ID}
    ./run_awscli dynamodb \
        delete-table --table-name terraform_locks

