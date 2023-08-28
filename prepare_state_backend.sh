#!/usr/bin/env bash

set -e


ACCOUNT="XXXXXXXX"
AWS_ACCOUNT="XXXXXXXXX"
RANDOM_SUFFIX="qzojghjc"

AWS_REGION="eu-central-1"
AWS_PROFILE="funnela-${ACCOUNT}"


BUCKET_NAME="terraform-state-funnela-${ACCOUNT}-${RANDOM_SUFFIX}"
DYNAMO_TABLE_NAME="terraform-state-lock-funnela-${ACCOUNT}-${RANDOM_SUFFIX}"
TERRAFORM_KEY="terraform/state"

aws s3api create-bucket \
	--region $AWS_REGION \
	--create-bucket-configuration LocationConstraint=$AWS_REGION \
	--bucket $BUCKET_NAME \
  --profile $AWS_PROFILE

aws dynamodb create-table \
	--region $AWS_REGION \
	--table-name $DYNAMO_TABLE_NAME \
	--attribute-definitions AttributeName=LockID,AttributeType=S \
	--key-schema AttributeName=LockID,KeyType=HASH \
	--provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1 \
  --profile $AWS_PROFILE


cat <<EOF
# Save this output in main.tf file

provider "aws" {
  region = "${AWS_REGION}"
  allowed_account_ids = ["${AWS_ACCOUNT}"]

  default_tags {
    tags = {
      ManagedBy = "terraform"
      Project = "Funnela"
      FunnelaAccount = "${ACCOUNT}"
    }
  }
}

terraform {
  backend "s3" {
    encrypt = true
    bucket = "${BUCKET_NAME}"
    dynamodb_table = "${DYNAMO_TABLE_NAME}"
    region = "${AWS_REGION}"
    key = "${TERRAFORM_KEY}"
  }
}

module "funnela" {
    source = "github.com/funnela/aws-terraform"

    # domain_name = "${ACCOUNT}.funnela.cloud"
    account = "${ACCOUNT}"

    azs =  ["${AWS_REGION}a", "${AWS_REGION}b", "${AWS_REGION}c"]

    db_instance_type = "db.t4g.small"
    redis_instance_type = "cache.t4g.micro"

    docker_image_version = "latest"
}
EOF
