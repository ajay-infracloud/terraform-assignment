data "aws_availability_zones" "available" {}

locals {
  private_subnet_count = var.max_subnet_count == 0 ? length(data.aws_availability_zones.available.names) : var.max_subnet_count
  public_subnet_count  = var.max_subnet_count == 0 ? length(data.aws_availability_zones.available.names) : var.max_subnet_count
}

# Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.aws_vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = var.default_tags
}

resource "aws_eip" "nat-eip" {
  vpc   = true
}

resource "aws_internet_gateway" "vpc-internetgw" {
  vpc_id = aws_vpc.vpc.id
 tags = merge(var.default_tags, tomap({
    "Name" = "${var.stack_name}-igw"
  }))
}


resource "aws_subnet" "subnets-public" {
  vpc_id            = aws_vpc.vpc.id
  count             = length(var.aws_availability_zones)
  availability_zone = element(var.aws_availability_zones, count.index)

  cidr_block = cidrsubnet(
    signum(length(var.aws_vpc_cidr_block)) == 1 ? var.aws_vpc_cidr_block : "10.0.0.0/20",
    ceil(log(local.public_subnet_count * 2, 2)),
    local.public_subnet_count + count.index
  )

  tags = merge(var.default_tags, tomap({
    "Name" = "${var.stack_name}-public-subnet"
  }))
}

resource "aws_subnet" "subnets-private" {
  vpc_id            = aws_vpc.vpc.id
  count             = length(var.aws_availability_zones)
  availability_zone = element(var.aws_availability_zones, count.index)

  cidr_block = cidrsubnet(
    signum(length(var.aws_vpc_cidr_block)) == 1 ? var.aws_vpc_cidr_block : "10.0.0.0/20",
    ceil(log(local.private_subnet_count * 2, 2)),
    count.index
  )

  tags = merge(var.default_tags, tomap({
    "Name" = "${var.stack_name}-private-subnet"
  }))
}

resource "aws_nat_gateway" "nat-gateway" {
  # count         = length(var.aws_availability_zones)
  allocation_id = aws_eip.nat-eip.id
  # subnet_id     = element(aws_subnet.subnets-public.*.id, count.index)
  subnet_id     = aws_subnet.subnets-public.0.id

  tags = merge(var.default_tags, tomap({
    "Name" = "${var.stack_name}-nat-gw"
  }))
}

resource "aws_route_table" "route-public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc-internetgw.id
  }

  tags = merge(var.default_tags, tomap({
    "Name" = "${var.stack_name}-public-route"
  }))
}

resource "aws_route_table" "route-private" {
  vpc_id = aws_vpc.vpc.id
  # count = length(var.aws_availability_zones)
  
  route {
    cidr_block     = "0.0.0.0/0"
    # nat_gateway_id = element(aws_nat_gateway.nat-gateway.*.id, count.index)
    nat_gateway_id = aws_nat_gateway.nat-gateway.id
  }

  tags = merge(var.default_tags, tomap({
    "Name" = "${var.stack_name}-private-route"
  }))
}

resource "aws_route_table_association" "rt-association-public" {
  count          = length(var.aws_availability_zones)
  subnet_id      = element(aws_subnet.subnets-public.*.id, count.index)
  route_table_id = aws_route_table.route-public.id
}

resource "aws_route_table_association" "rt-association-private" {
  count          = length(var.aws_availability_zones)
  subnet_id      = element(aws_subnet.subnets-private.*.id, count.index)
  # route_table_id = element(aws_route_table.route-private.*.id, count.index)
  route_table_id = aws_route_table.route-private.id
}


