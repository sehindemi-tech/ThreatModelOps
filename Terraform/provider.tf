## Root/provider.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.0.0"
    }
  }
  backend "s3" {
    bucket       = "threat-composer-ops-aws"
    key          = "state/terraform.tfstate"
    region       = "eu-west-2"
    use_lockfile = true
  }
}

provider "aws" {
  region = var.vpc_region
  default_tags {
    tags = {
      App = var.project_name
    }
  }
}

