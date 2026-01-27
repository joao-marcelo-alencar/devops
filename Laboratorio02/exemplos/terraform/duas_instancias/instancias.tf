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

