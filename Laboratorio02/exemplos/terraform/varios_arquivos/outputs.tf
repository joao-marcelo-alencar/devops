output "instance_public_ip" {
  description = "Endereço IP público da instância EC2"
  value       = aws_instance.servidor_devops.public_ip
}

output "instance_id" {
  description = "ID da instância EC2"
  value       = aws_instance.servidor_devops.id
}

output "instance_private_ip" {
  description = "Endereço IP privado da instância EC2"
  value       = aws_instance.servidor_devops.private_ip
}

output "security_group_id" {
  description = "ID do Security Group"
  value       = aws_security_group.devops.id
}

output "instance_public_dns" {
  description = "DNS público da instância EC2"
  value       = aws_instance.servidor_devops.public_dns
}
