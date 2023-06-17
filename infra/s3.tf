resource "aws_s3_bucket" "tickit_data_bucket" {
  bucket = var.tickit_bucket_name

  lifecycle {
    create_before_destroy = true
  }
}