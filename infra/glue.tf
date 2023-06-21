# classifier
resource "aws_glue_classifier" "csv_with_header_classifier" {
  name = "csv-with-header-classifier"

  csv_classifier {
    allow_single_column    = false
    contains_header        = "PRESENT"
    delimiter              = ","
    disable_value_trimming = false
    quote_symbol           = "'"
  }
}

resource "aws_glue_catalog_database" "aws_glue_catalog_database" {
  name = "tickit_raw"
}

resource "aws_glue_crawler" "csv-crawler" {
  database_name = aws_glue_catalog_database.aws_glue_catalog_database.name
  name          = "csv-crawler"
  role          = aws_iam_role.glue_role.arn
  classifiers   = [aws_glue_classifier.csv_with_header_classifier.name]

  s3_target {
    path = "s3://${var.tickit_bucket_name}"
  }
}

resource "aws_glue_connection" "glue_redshift_connection" {
  depends_on = [aws_redshiftserverless_workgroup.workgroup]

  connection_properties = {
    JDBC_CONNECTION_URL = "jdbc:redshift://${var.redshift_workgroup_name}.102606406933.eu-central-1.redshift-serverless.amazonaws.com:5439/${var.redshift_database_name}"
    USERNAME            = var.redshift_admin_username
    PASSWORD            = var.redshift_admin_password
  }

  physical_connection_requirements {
    availability_zone      = aws_subnet.redshift-subnet-az4.availability_zone
    security_group_id_list = [aws_security_group.security-group-redshift.id]
    subnet_id              = aws_subnet.redshift-subnet-az4.id
  }

  name = "glue-redshift-connection"
}