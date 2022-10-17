variable "stack_name" {
  description = "Stack Name"
}
variable "vpc_public_nat_ip" {
  description = "Identifier of Database"
}

variable "database_identifier" {
  description = "Identifier of Database"
}

variable "database_size" {
  description = "Size of RDS Instance"
}

variable "storage_type" {
  description = "Storage type of RDS Instance"
}

variable "database_engine" {
  description = "Database engine"
}

variable "database_version" {
  description = "Version of database engine"
}

variable "database_instance_class" {
  description = "Database instance class"
}

variable "database_name" {
  description = "Name of Databse"
}

variable "database_username" {
  description = "username for databse"
  type        = string
}

variable "database_password" {
  description = "Databse password"
  type        = string
}

variable "multiaz" {
  description = "RDS instance in multi availibility zones enable or not"
  #  type        = bool
}

variable "aws_avail_zones" {
  description = "AWS Availability Zones Used"
  type        = list
}

variable "auto_version" {
  description = "Whether auto version upgrade set to true or false"
}

variable "backup_period" {
  description = "Backup retention period for RDS instance"
}

variable "family" {
  description = "family of parameter group"
}

variable "subnet_group_ids" {
  description = "Subnet ids of VPC to launch RDS instance"
}

variable "vpc_id" {
  description = "Subnet ids of VPC to launch RDS instance"
}

variable "aws_vpc_cidr_block" {
  description = "Subnet ids of VPC to launch RDS instance"
  type        = list
}

variable "public_accessible" {
  description = "Database accessible publicly or not"
}

variable "final_snapshot_identifier" {
  description = "Identifier of rds final snapshot"
}

variable "default_tags" {
  description = "Default tags for all resources"
  type        = map
}

variable "ec2_sg_id" {
  
}