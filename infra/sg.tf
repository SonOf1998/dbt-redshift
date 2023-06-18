resource "aws_security_group" "security-group-redshift" {
  # depends_on = [aws_vpc.vpc-redshift]

  name        = "Redshift-SG"
  description = "Security group for Redshift"

  vpc_id = aws_vpc.vpc-redshift.id
  
  ingress {
    description = "Redshift port"
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = var.dbt_ip_addresses
  }
  
  tags = {
    Name        = "Redshift SG"
  }
}