terraform {
  backend "s3" {
    bucket = "terraform-states-mkis-${var.region}"
    key    = "dbt-redshift"
    region = var.region
  }
}