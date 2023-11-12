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

module "vpc" {
  source = "./vpc"

  env      = var.env
  azs      = var.azs
  vpc_cidr = var.vpc_cidr
}

module "database" {
  source = "./database"

  env                    = var.env
  azs                    = var.azs
  vpc_cidr               = var.vpc_cidr
  vpc_id                 = module.vpc.vpc_id
  vpc_private_subnet_ids = module.vpc.vpc_private_subnet_ids
}

module "iam" {
  source = "./iam"

  bucket_arn = module.storage.bucket_arn
}

module "storage" {
  source = "./storage"
}

module "app" {
  source = "./app"

  env    = var.env
  db_url = module.database.db_url
}