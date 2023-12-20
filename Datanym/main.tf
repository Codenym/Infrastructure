terraform {
  cloud {
    organization = "codenym"
    workspaces {
      name = "datanym"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

module "database" {
  source                 = "./database"
}

module "iam" {
  source = "./iam"
  bucket_arn = module.storage.bucket_arn
}

module "storage" {
  source = "./storage"
}

#module "fixtures_datasette" {
#  source             = "./datasette"
#  function_name      = "fixtures_datasette"
#  deployment_directory = "inputs/datasette_deployment/fixtures/deployment_package"
#  lambda_role_arn    = module.iam.lambda_role_arn
#}
#
#module "irs527" {
#  source             = "./datasette"
#  function_name      = "irs527"
#  deployment_directory = "inputs/datasette_deployment/irs527/deployment_package"
#  lambda_role_arn    = module.iam.lambda_role_arn
#}