variable "region" {
  description   = "AWS Region"
  type          = string
}

variable "tickit_bucket_name" {
  description   = "Bucket name for the raw data"
  type          = string
}

variable "redshift_vpc_cidr" {
  type          = string
  description   = "VPC IPv4 CIDR"
}

variable "redshift_subnet_1_cidr" {
  type          = string
  description   = "IPv4 CIDR for Redshift subnet 1"
}

variable "redshift_subnet_2_cidr" {
  type          = string
  description   = "IPv4 CIDR for Redshift subnet 2"
}

variable "redshift_subnet_3_cidr" {
  type          = string
  description   = "IPv4 CIDR for Redshift subnet 3"
}

variable "redshift_namespace_name" {
  type        = string
  description = "Redshift Serverless Namespace Name"
}

variable "redshift_database_name" { 
  type        = string
  description = "Redshift Serverless Database Name"
}

variable "redshift_admin_username" {
  type        = string
  description = "Redshift Serverless Admin Username"
}

variable "redshift_admin_password" { 
  type        = string
  description = "Redshift Serverless Admin Password"
}

variable "redshift_workgroup_name" {
  type        = string
  description = "Redshift Serverless Workgroup Name"
}

variable "redshift_base_capacity" {
  type        = number
  description = "Redshift Serverless Base Capacity"
  default     = 32 // 32 RPUs to 512 RPUs in units of 8 (32,40,48...512)
}

variable "redshift_publicly_accessible" {
  type        = bool
  description = "Set the Redshift Serverless to be Publicly Accessible"
  default     = false
}