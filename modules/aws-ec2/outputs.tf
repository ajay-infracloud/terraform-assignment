output "ec2-sg" {
    value = aws_security_group.sg
}

output "ec2_ip" {
    value = aws_instance.instance.*.public_ip
}