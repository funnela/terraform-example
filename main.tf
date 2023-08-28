provider "aws" {
  region = "eu-central-1"
  allowed_account_ids = ["XXXXXXXX"]

  default_tags {
    tags = {
      ManagedBy = "terraform"
      Project = "Funnela"
      FunnelaAccount = "XXXXXX"
    }
  }
}

terraform {
  backend "s3" {
    encrypt = true
    bucket = "terraform-state-funnela-XXXX-qzojghjc"
    dynamodb_table = "terraform-state-lock-funnela-XXXXX-qzojghjc"
    region = "eu-central-1"
    key = "terraform/state"
  }
}

module "funnela" {
    source = "github.com/funnela/aws-terraform"

    domain_name = "XXXXXXX.funnela.cloud"
    account = "XXXXX"

    azs =  ["eu-central-1a", "eu-central-1b", "eu-central-1c"]

    db_instance_type = "db.t3.small"
    redis_instance_type = "cache.t4g.micro"

    docker_image_version = "latest"

    web_service_scale = 2
    # web_service_cpu = 512
    # web_service_mem = 1024

    bastion_enable = true
    bastion_authorized_keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC5iWKH+I7QOxbQS2WSN2qm1iU9LKMAA1gYcwUXUTQyJ48UDUdBzZz4kwnVLByyNptkUYruw+nOXDGoluyKTtPSqBLJCmeaVyZB8sk2eAXA7pPlScQk4gJcjEltTGxvF168TUsoSfMRC5TWnqfilXVWqlkY/h6DtQzHEG+O8RO7ClVdEmcUkMrLtdbhGtExTXHZMgkDzjQjfIT86FKqV5X1Rf+f5JcYBaflal6t0TooW6n5X2++j7dbryadBNQpI68Y+jOKf0FSUOp5MawGdqLJjXTogfTizS6uqEuQSZ+vXMi5HGjv6hI4iaoiYPMFGGyZhHZBFspqkGkngQmmPT2qsdUyAl0tYYD62NQ93BNYwa+2pMahRXLtgvGdbQCGnwtdX46xDWaU5cnWFClBNM8J6nh5wbYOblkOjZihnOEQUwBSxPhO8mBCABEQq7jGHxJ+nDUTmuwthFnmTLCeIHcvszTsbiDJTsJksE2WqMUkquZaNyITGUaYOp0RvxzSGmJjrq8QFXP2MoqomBJ9m+rUwrE0n3Ldlye5LHR+zm/wNQrMWKZ1yXbOB2/UQfgux24YjhQfR4ZjsU5R+tNh3kc3xgGchvt2ns6fZOGeS0tPEWAY/MWlkxL2kwt2KdPBgy3YVS+/dU473VWiwUNHJ9pSCv452Z+ndqmqQM+R8Hmwbw== john@mbp.local"
}
