# workgroup
resource "aws_redshiftserverless_workgroup" "workgroup" {
  depends_on = [aws_redshiftserverless_namespace.namespace]

  namespace_name = aws_redshiftserverless_namespace.namespace.id
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
resource "aws_redshiftserverless_namespace" "namespace" {
  namespace_name      = var.redshift_namespace_name
  db_name             = var.redshift_database_name
  admin_username      = var.redshift_admin_username
  admin_user_password = var.redshift_admin_password
  iam_roles           = [aws_iam_role.redshift-role.arn]
}