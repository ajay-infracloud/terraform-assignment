stack_name = "Infracloud-test"
aws_vpc_cidr_block = "10.0.0.0/16"
max_subnet_count = 3

default_tags = {
    Name = "Infracloud-test",
    Owner = "Ajay"
}

ec2_properties = {
  ami_id = "ami-06672d07f62285d1d"
  instance_type = "t3.micro"
  instance_count = 1
  ebs_volume_size = "10"
  whitelisted_ips = ["53.216.12.222/32", "121.22.12.3/32", "0.0.0.0/0" ] #random ips.
}

rds_properties = {
  database_size             = 10
  storage_type              = "gp2"
  database_engine           = "postgres"
  database_version          = "13.7"
  database_instance_class   = "db.t3.micro"
  database_name             = "Infracloud"
  database_username         = "root"
  database_password         = "CQMDdERQBmUAM0An4PupZ24PO"
  multiaz                   = "false"
  auto_version              = "false"
  backup_period             = 0
  family                    = "postgres13"
  public_accessible         = "false"  
} 