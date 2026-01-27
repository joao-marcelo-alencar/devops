resource "aws_instance" "servidorweb" {
  ami             = "ami-0c7217cdde317cfec"
  instance_type   = "t2.micro"
  key_name        = "vockey"
  security_groups = [ aws_security_group.web.name ]

  tags = {
    Name = var.nome_instancia_web
  }
}

resource "aws_instance" "servidorbancodedados" {
  ami             = "ami-0c7217cdde317cfec"
  instance_type   = "t2.micro"
  key_name        = "vockey"
  security_groups = [ aws_security_group.bancodedados.name ]

  tags = {
    Name = var.nome_instancia_bd
  }
}

output "web_server_public_ip" {
  description = "Endereço IP público do servidor web"
  value       = aws_instance.servidorweb.public_ip
}

output "web_server_id" {
  description = "ID da instância do servidor web"
  value       = aws_instance.servidorweb.id
}

output "database_server_public_ip" {
  description = "Endereço IP público do servidor de banco de dados"
  value       = aws_instance.servidorbancodedados.public_ip
}

output "database_server_id" {
  description = "ID da instância do servidor de banco de dados"
  value       = aws_instance.servidorbancodedados.id
}

