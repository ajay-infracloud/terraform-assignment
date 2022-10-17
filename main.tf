
data "aws_availability_zones" "available" {}

module "vpc" {
    source = "./modules/aws-vpc"
    aws_vpc_cidr_block = var.aws_vpc_cidr_block
    aws_availability_zones    = slice(data.aws_availability_zones.available.names, 0, 3)
    default_tags       = var.default_tags
    max_subnet_count   = var.max_subnet_count    
    stack_name         = var.stack_name
}

resource "tls_private_key" "tls_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "${var.stack_name}-key"
  public_key = tls_private_key.tls_key.public_key_openssh
}

module "ec2" {
    source = "./modules/aws-ec2"
    stack_name             = var.stack_name
    aws_vpc_id             = module.vpc.aws_vpc.id
    aws_vpc_cidr_block     = concat(formatlist("%s/32", module.vpc.vpc_ngw.*.public_ip), [var.aws_vpc_cidr_block])
    public_subnet_id       = module.vpc.subnets_public.*.id
    aws_ec2_ami_id         = var.ec2_properties.ami_id
    aws_ec2_instance_type  = var.ec2_properties.instance_type
    aws_ec2_instance_count = var.ec2_properties.instance_count
    aws_ec2_ssh_key_name   = aws_key_pair.ssh_key.key_name
    aws_ec2_volume_size    = var.ec2_properties.ebs_volume_size
    availability_zones     = data.aws_availability_zones.available.names
    whitelisted_ips        = var.ec2_properties.whitelisted_ips
    default_tags           = var.default_tags   
}

module "aws-rds" {
  source = "./modules/aws-rds"
  stack_name                = var.stack_name
  database_identifier       = var.stack_name
  database_size             = var.rds_properties.database_size
  storage_type              = var.rds_properties.storage_type
  database_engine           = var.rds_properties.database_engine
  database_version          = var.rds_properties.database_version
  database_instance_class   = var.rds_properties.database_instance_class
  database_name             = var.rds_properties.database_name
  database_username         = var.rds_properties.database_username
  database_password         = var.rds_properties.database_password
  multiaz                   = var.rds_properties.multiaz
  auto_version              = var.rds_properties.auto_version
  backup_period             = var.rds_properties.backup_period
  public_accessible         = var.rds_properties.public_accessible
  final_snapshot_identifier = "rds-${var.stack_name}-snapshot"
  family                    = var.rds_properties.family
  aws_avail_zones           = slice(data.aws_availability_zones.available.names, 0, 1)
  aws_vpc_cidr_block        = [module.vpc.aws_vpc.cidr_block]
  subnet_group_ids          = module.vpc.subnets_private.*.id
  vpc_id                    = module.vpc.aws_vpc.id
  vpc_public_nat_ip         = module.vpc.vpc_ngw.*.public_ip
  default_tags              = var.default_tags
  ec2_sg_id                 = module.ec2.ec2-sg.id
}

