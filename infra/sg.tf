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
    cidr_blocks = ["52.45.144.63/32", "54.81.134.249/32", "54.81.134.249/32"]
  }
  
  tags = {
    Name        = "Redshift SG"
  }
}