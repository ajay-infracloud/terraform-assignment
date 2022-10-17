resource "aws_security_group" "sg" {
  name   = "${var.stack_name}-ec2-securitygroup"
  vpc_id = var.aws_vpc_id

  tags = merge(var.default_tags, tomap({
    "Name" = "${var.stack_name}-ec2-securitygroup"
    }))
}

resource "aws_security_group_rule" "allow-ssh-connections" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "TCP"
  cidr_blocks       = concat(var.aws_vpc_cidr_block, var.whitelisted_ips)
  security_group_id = aws_security_group.sg.id
}

resource "aws_security_group_rule" "allow-outgoing-connections" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg.id
}

resource "aws_instance" "instance" {
  ami                         = var.aws_ec2_ami_id
  instance_type               = var.aws_ec2_instance_type
  count                       = var.aws_ec2_instance_count
  availability_zone           = element(slice(var.availability_zones, 0, 1), count.index)
  subnet_id                   = element(var.public_subnet_id, count.index)
  vpc_security_group_ids      = [aws_security_group.sg.id]
  key_name                    = var.aws_ec2_ssh_key_name
  ebs_optimized               = true
  associate_public_ip_address = true

  credit_specification {
    cpu_credits = "standard"
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = var.aws_ec2_volume_size
  }

  tags = merge(var.default_tags, tomap({
    "Name" = "ec2-${var.stack_name}-${count.index}"
    }))
}