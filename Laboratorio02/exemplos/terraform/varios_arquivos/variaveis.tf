variable "nome_instancia" {
  description = "Nome da Instancia"
  type        = string
  default     = "InstanciaDevOps"
}

output "public_ip" {
  value       = aws_instance.servidor_devops.public_ip
  description = "IP Publico"
}

output "instance_id" {
  value       = aws_instance.servidor_devops.id
  description = "Identificador da Instancia"
}
