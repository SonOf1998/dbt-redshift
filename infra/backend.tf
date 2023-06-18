terraform {
  # backend does not allow variables
  backend "s3" {
    bucket = "terraform-states-mkis-eu-central-1"
    key    = "dbt-redshift"
    region = "eu-central-1"
  }
}