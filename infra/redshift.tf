# workgroup
resource "aws_redshift_workgroup" "serverless" {
  # depends_on = [aws_redshift_namespace.serverless]

  namespace_name = aws_redshift_namespace.serverless.id
  workgroup_name = var.redshift_workgroup_name
  base_capacity  = var.redshift_base_capacity
  
  security_group_ids = [ aws_security_group.security-group-redshift.id ]
  subnet_ids         = [ 
    aws_subnet.redshift-subnet-az1.id,
    aws_subnet.redshift-subnet-az2.id,
    aws_subnet.redshift-subnet-az3.id,
  ]
  publicly_accessible = var.redshift_publicly_accessible
}

# namespace
resource "aws_redshift_namespace" "serverless" {
  namespace_name      = var.redshift_namespace_name
  db_name             = var.redshift_database_name
  admin_username      = var.redshift_admin_username
  admin_user_password = var.redshift_admin_password
  iam_roles           = [aws_iam_role.redshift-role.arn]
}