resource "aws_security_group" "web" {
  name        = "web"
  description = "Grupo de Seguranca para Servidor Web"

  tags = {
    Name = "web"
  }
}

resource "aws_vpc_security_group_ingress_rule" "permitir_http_ipv4" {
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "permitir_http_ipv4_web" {
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "trafego_saida_web" {
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_security_group" "bancodedados" {
  name        = "bancodedados"
  description = "Grupo de Seguranca para Servidor Banco de Dados"

  tags = {
    Name = "bancodedados"
  }
}

resource "aws_vpc_security_group_ingress_rule" "permitir_mysql_ipv4" {
  security_group_id            = aws_security_group.bancodedados.id
  referenced_security_group_id = aws_security_group.web.id
  from_port                    = 3306
  ip_protocol                  = "tcp"
  to_port                      = 3306
}

resource "aws_vpc_security_group_ingress_rule" "permitir_http_ipv4_bd" {
  security_group_id = aws_security_group.bancodedados.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "trafego_saida_bd" {
  security_group_id = aws_security_group.bancodedados.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}


