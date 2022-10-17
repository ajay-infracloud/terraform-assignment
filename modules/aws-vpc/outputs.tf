output "aws_vpc" {
  value = aws_vpc.vpc
}

output "subnets_private" {
  value = aws_subnet.subnets-private
}

output "subnets_public" {
  value = aws_subnet.subnets-public
}

output "vpc_ngw" {
  value = aws_nat_gateway.nat-gateway
}