# Native Terraform tests (Terraform >= 1.6). Run from modules/networking:
#   terraform init && terraform test
# command = plan  ->  creates NOTHING in AWS, so it costs $0.

provider "aws" {
  region = "ap-southeast-1"
}

run "creates_one_subnet_per_cidr" {
  command = plan

  variables {
    name                = "test"
    vpc_cidr            = "10.0.0.0/16"
    public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  }

  assert {
    condition     = length(aws_subnet.public) == 2
    error_message = "Expected 2 public subnets."
  }
}

run "rejects_invalid_vpc_cidr" {
  command = plan

  variables {
    name                = "test"
    vpc_cidr            = "not-a-cidr"
    public_subnet_cidrs = ["10.0.1.0/24"]
  }

  expect_failures = [var.vpc_cidr]
}
