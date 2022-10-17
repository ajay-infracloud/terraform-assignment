output "private_key" {
  value     = tls_private_key.tls_key.private_key_pem
  sensitive = true
}

output "ec2_instance_ip" {
  value = module.ec2.ec2_ip
}

output "rds_endpoint" {
  value = module.aws-rds.rds_endpoint
}