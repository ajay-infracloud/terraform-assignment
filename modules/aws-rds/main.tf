resource "aws_security_group" "rds_security_group" {
  name   = "${var.stack_name}-rds-security-group"
  vpc_id = var.vpc_id

  tags = merge(var.default_tags, tomap({
    "Name" = "${var.stack_name}-rds-security-group"
    }))
}

resource "aws_security_group_rule" "allow-database-all-ingress" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = concat(formatlist("%s/32", var.vpc_public_nat_ip), var.aws_vpc_cidr_block)
  security_group_id = aws_security_group.rds_security_group.id
}

resource "aws_security_group_rule" "allow-database-from-ec2" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  security_group_id = aws_security_group.rds_security_group.id
  source_security_group_id = var.ec2_sg_id
}

resource "aws_security_group_rule" "allow-outgoing-connections" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rds_security_group.id
}

resource "aws_db_subnet_group" "db_subnet_group" {
  subnet_ids = var.subnet_group_ids

  tags = merge(var.default_tags, tomap({
    "Name" = "${var.stack_name}-dbsubnetgroup"
    }))
}

resource "aws_db_parameter_group" "db_parameter_group" {
  family = var.family

  tags = merge(var.default_tags, tomap({
    "Name" = "${var.stack_name}-dbparametergroup"
    }))
}

resource "aws_db_instance" "db_cluster" {
  identifier                 = lower(var.database_identifier)
  allocated_storage          = var.database_size
  storage_type               = var.storage_type
  engine                     = var.database_engine
  engine_version             = var.database_version
  instance_class             = var.database_instance_class
  db_name                    = var.database_name
  username                   = var.database_username
  password                   = var.database_password
  db_subnet_group_name       = aws_db_subnet_group.db_subnet_group.name
  parameter_group_name       = aws_db_parameter_group.db_parameter_group.name
  multi_az                   = var.multiaz
  vpc_security_group_ids     = [aws_security_group.rds_security_group.id]
  publicly_accessible        = var.public_accessible
  final_snapshot_identifier  = var.final_snapshot_identifier
  count                      = length(var.aws_avail_zones)
  availability_zone          = element(var.aws_avail_zones, count.index)
  auto_minor_version_upgrade = var.auto_version
  backup_retention_period    = var.backup_period

  tags = merge(var.default_tags, tomap({
    "Name" = "${var.stack_name}-rds"
  }))
}
