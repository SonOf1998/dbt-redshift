terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  cloud {
    organization = "makis"
    token = "asd"

    workspaces {
      name       = "dbt-redshift"
    }
  }
}

provider "aws" {
  region  = var.region
}