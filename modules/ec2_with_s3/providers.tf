provider "aws" {
  region = "eu-central-1"
  alias  = "eu_central_1"
}

provider "aws" {
  region = "us-east-1"
  alias  = "us_east_1"
}

data "aws_caller_identity" "current" {}
