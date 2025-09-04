output "instance_id" {
  description = "ID of the Ubuntu instance"
  value       = aws_instance.ubuntu_private.id
}

output "instance_name" {
  description = "Name of the Ubuntu instance"
  value       = var.instance_name
}

output "private_ip" {
  description = "Private IP address of the Ubuntu instance"
  value       = aws_instance.ubuntu_private.private_ip
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i ${var.key_name}.pem ubuntu@${aws_instance.ubuntu_private.private_ip}"
}

output "private_key_filename" {
  description = "Name of the generated private key file"
  value       = "${var.key_name}.pem"
}

output "key_pair_name" {
  description = "Name of the AWS key pair"
  value       = aws_key_pair.ubuntu_key.key_name
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.ubuntu_private_sg.id
}

output "security_group_name" {
  description = "Name of the security group"
  value       = aws_security_group.ubuntu_private_sg.name
}