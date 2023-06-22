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

# subnet4 (used by the EC2 for the Glue job)
resource "aws_subnet" "redshift-subnet-az4" {
  vpc_id            = aws_vpc.vpc-redshift.id
  cidr_block        = var.redshift_subnet_4_cidr
  availability_zone = data.aws_availability_zones.AZs.names[0]
}

# static IP address to NAT gateway
resource "aws_eip" "eip_glue_nat_gateway" {
  domain = "vpc"
}

# nat gateway
resource "aws_nat_gateway" "glue_nat_gateway" {
  allocation_id = aws_eip.eip_glue_nat_gateway.id
  subnet_id     = aws_subnet.redshift-subnet-az1.id
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

resource "aws_route" "ingress_route_fallback" {
  route_table_id = aws_vpc.vpc-redshift.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.redshift-vpc-igw.id
}

resource "aws_route_table" "glue_nat_route_table" {
  vpc_id = aws_vpc.vpc-redshift.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.glue_nat_gateway.id
  }

  tags = {
    Name = "Glue NAT routing"
  }
}

resource "aws_route_table_association" "glue_route_association" {
  subnet_id      = aws_subnet.redshift-subnet-az4.id
  route_table_id = aws_route_table.glue_nat_route_table.id
}