# Ansible - Inventário Dinâmico AWS

Este diretório contém playbooks Ansible configurados para usar **inventário dinâmico** da AWS, que descobre automaticamente as instâncias EC2 criadas pelo Terraform.

## O que é Inventário Dinâmico?

Inventário dinâmico permite que o Ansible descubra automaticamente hosts na AWS sem precisar manter manualmente uma lista de IPs no arquivo `inventory.ini`.

### Vantagens

✅ **Automático**: Descobre instâncias EC2 em tempo real  
✅ **Sem Manutenção**: Não precisa atualizar IPs manualmente  
✅ **Escalável**: Funciona com 1 ou 1000 instâncias  
✅ **Filtros Inteligentes**: Agrupa por tags, tipos, regiões  
✅ **Sempre Atualizado**: Consulta AWS a cada execução

## Pré-requisitos

### ✅ Verificar Instalações

Confirme que os seguintes componentes já estão instalados:

```bash
# Verificar Ansible
ansible --version
# Esperado: ansible [core 2.x.x] ou superior

# Verificar Python
python3 --version
# Esperado: Python 3.8 ou superior

# Verificar boto3 (SDK AWS para Python)
python3 -c "import boto3; print(boto3.__version__)"
# Se der erro, instale: pip3 install boto3 botocore

# Verificar AWS CLI
aws --version
# Esperado: aws-cli/2.x.x ou superior
```

### ✅ Recursos AWS Criados

Este playbook requer que a infraestrutura já tenha sido criada com Terraform:

```bash
# Verificar se as instâncias estão rodando
cd ../../../Laboratorio02/exemplos/terraform/duas_instancias

# Ver outputs do Terraform
terraform output
```

### ✅ Credenciais AWS Configuradas

```bash
# Verificar credenciais
aws sts get-caller-identity

# Se não configurado, configure:
aws configure
```

### ✅ Chave SSH

Usar a chave labsuser.pem fornecida pela AWS Academy.

## Configuração do Inventário Dinâmico

### Arquivo: `aws_ec2.yml`

Este arquivo configura como o Ansible descobre instâncias na AWS. Você deve apontá-lo como inventório.

## Passo a Passo de Execução

### Testar Inventário Dinâmico

```bash
# Listar todos os hosts descobertos pela AWS
ansible-inventory -i aws_ec2.yml --list

# Ver estrutura em árvore
ansible-inventory -i aws_ec2.yml --graph
```

### Verificar Conectividade

```bash
# Testar ping em todos os hosts
ansible -i aws_ec2.yml all -m ping
```

### Verificar Sintaxe do Playbook

```bash
# Validar sintaxe
ansible-playbook playbook.yml --syntax-check
```

### Executar o Playbook

```bash
# Executar normalmente
ansible-playbook -i aws_ec2.yml playbook.yml
```

