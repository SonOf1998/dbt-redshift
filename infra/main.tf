terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  cloud {
    organization = "makis"

    workspaces {
      name       = "dbt-redshift"
    }
  }
}

provider "aws" {
  region  = var.region
}