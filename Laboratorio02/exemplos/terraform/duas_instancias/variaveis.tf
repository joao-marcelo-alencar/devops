variable "nome_instancia_web" {
  description = "Nome da Instancia do Servidor Web"
  type        = string
  default     = "InstanciaNginx"
}

variable "nome_instancia_bd" {
  description = "Nome da Instancia do Servidor de Banco de Dados"
  type        = string
  default     = "InstanciaMySql"
}


output "public_ip_web" {
  value       = aws_instance.servidorweb.public_ip
  description = "IP Publico do Servidor Web"
}

output "public_ip_db" {
  value       = aws_instance.servidorbancodedados.public_ip
  description = "IP Publico do Banco de Dados"
}

