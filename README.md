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
 - After: `./run-terraform.sh apply` or any other command.

Gotchas
-------

 - Optional: Change the root directory if different in `terraform-common.sh`
 - The account ID is restricted. You might want to change
   `provider.tf` and/or `terraform-vars.sh`
 - export the variable `DISABLE_DOCKER=1` to use `awscli` and `terraform` directly.

Importing this repo into another
--------------------------------

You can clone this repo into a subdirectory of other repo, by simply following
the following process (Originally [suggested here](https://stackoverflow.com/a/1684694/395686)):

   TARGET_DIRECTORY=somedir # Change to the actual target in the current directory

   git remote add terraform_boilerplate https://github.com/keymon/terraform_boilerplate
   git fetch terraform_boilerplate
   git checkout -b terraform_boilerplate_tmp terraform_boilerplate/master
   mkdir -p ${TARGET_DIRECTORY}
   git ls-files | cut -f 1 -d / | sort | uniq | \
      xargs -n1 -I {} git mv "{}" "${TARGET_DIRECTORY}/{}"
   git commit -m "Moving all terraform_boilerplate to ${TARGET_DIRECTORY}"
   git checkout master
   git merge terraform_boilerplate_tmp --allow-unrelated-histories
   git remote rm terraform_boilerplate
   git branch -d terraform_boilerplate_tmp


Clean up
--------

To delete the S3 bucket and dynamo db table of the terraform state:

    ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text | tr -d '\r')"
    PROJECT_ROOT=$(git rev-parse --show-toplevel)
    PROJECT_NAME="${PROJECT_ROOT##*/}"
    export AWS_DEFAULT_REGION=eu-west-1

    ./run-aws.sh s3 ls s3://terraform-tfstate-${ACCOUNT_ID}
    ./run-aws.sh s3 rm --recursive s3://terraform-tfstate-${ACCOUNT_ID}/${PROJECT_NAME}.tfstate
    ./run-aws.sh s3api \
        delete-bucket \
        --bucket terraform-tfstate-${ACCOUNT_ID}
    ./run-aws.sh dynamodb \
        delete-table --table-name terraform_locks

