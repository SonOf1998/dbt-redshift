# query AZs
data "aws_availability_zones" "AZs" {
  state = "available"
}
 
# VPC
resource "aws_vpc" "vpc-redshift" {
  cidr_block            = var.redshift_serverless_vpc_cidr
  enable_dns_hostnames  = true

  tags = {
    Name                = "Redshift VPC"
  }
}

# subnet1 
resource "aws_subnet" "redshift-subnet-az1" {
  vpc_id            = aws_vpc.vpc-redshift.id
  cidr_block        = var.redshift_serverless_subnet_1_cidr
  availability_zone = data.aws_availability_zones.AZs.names[0]
}

# subnet2
resource "aws_subnet" "redshift-subnet-az2" {
  vpc_id            = aws_vpc.vpc-redshift.id
  cidr_block        = var.redshift_serverless_subnet_2_cidr
  availability_zone = data.aws_availability_zones.AZs.names[1]
}

# subnet3
resource "aws_subnet" "redshift-subnet-az3" {
  vpc_id            = aws_vpc.vpc-redshift.id
  cidr_block        = var.redshift_serverless_subnet_3_cidr
  availability_zone = data.aws_availability_zones.AZs.names[2]
}