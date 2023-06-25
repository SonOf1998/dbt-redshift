resource "aws_glue_job" "example" {
  name     = "TICKIT ETL: from Glue to Redshift"
  role_arn = aws_iam_role.glue_role.arn
  glue_version = "4.0"
  timeout = 30

  command {
    script_location = "s3://${var.tickit_bucket_name}/etl/tickit_from_glue_to_redshift.py"
  }

  default_arguments = {
    "--tables" = "category,date,event,listing,sale,user,venue"
  }
}