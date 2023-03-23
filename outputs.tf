output "ip_address"{
    description = "Our EC2 public ip"
    value = aws_instance.ec2_instance.public_ip
}