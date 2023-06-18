# query AZs
data "aws_availability_zones" "AZs" {
  state = "available"
}
 
# VPC
resource "aws_vpc" "vpc-redshift" {
  cidr_block            = var.redshift_vpc_cidr
  enable_dns_hostnames  = true

  tags = {
    Name                = "Redshift VPC"
  }
}

# subnet1 
resource "aws_subnet" "redshift-subnet-az1" {
  vpc_id            = aws_vpc.vpc-redshift.id
  cidr_block        = var.redshift_subnet_1_cidr
  availability_zone = data.aws_availability_zones.AZs.names[0]
}

# subnet2
resource "aws_subnet" "redshift-subnet-az2" {
  vpc_id            = aws_vpc.vpc-redshift.id
  cidr_block        = var.redshift_subnet_2_cidr
  availability_zone = data.aws_availability_zones.AZs.names[1]
}

# subnet3
resource "aws_subnet" "redshift-subnet-az3" {
  vpc_id            = aws_vpc.vpc-redshift.id
  cidr_block        = var.redshift_subnet_3_cidr
  availability_zone = data.aws_availability_zones.AZs.names[2]
}

# igw
resource "aws_internet_gateway" "redshift-vpc-igw" {
  vpc_id = aws_vpc.vpc-redshift.id

  tags = {
    Name = "Redshift-IGW"
  }
}

# extending default route table
resource "aws_route" "ingress_route1" {
  route_table_id = aws_vpc.vpc-redshift.default_route_table_id
  destination_cidr_block = var.dbt_ip_addresses[0]
  gateway_id = aws_internet_gateway.redshift-vpc-igw.id
}

resource "aws_route" "ingress_route2" {
  route_table_id = aws_vpc.vpc-redshift.default_route_table_id
  destination_cidr_block = var.dbt_ip_addresses[1]
  gateway_id = aws_internet_gateway.redshift-vpc-igw.id
}

resource "aws_route" "ingress_route3" {
  route_table_id = aws_vpc.vpc-redshift.default_route_table_id
  destination_cidr_block = var.dbt_ip_addresses[2]
  gateway_id = aws_internet_gateway.redshift-vpc-igw.id
}
