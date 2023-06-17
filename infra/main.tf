terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  cloud {
    organization = "makis"
    host         = "app.terraform.io"

    workspaces {
      name       = "dbt-redshift"
    }
  }
}

provider "aws" {
  region  = var.region
}