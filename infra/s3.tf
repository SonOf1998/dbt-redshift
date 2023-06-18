resource "aws_s3_bucket" "tickit_data_bucket" {
  bucket = var.tickit_bucket_name

  force_destroy = true
}