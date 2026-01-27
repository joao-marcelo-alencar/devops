# Terraform - Vários Arquivos (Estrutura Modular)

Este diretório demonstra a **melhor prática** de organizar código Terraform em múltiplos arquivos, separando responsabilidades e facilitando a manutenção.

## Vantagens da Estrutura Modular

✅ **Organização**: Cada arquivo tem uma responsabilidade específica  
✅ **Manutenibilidade**: Mais fácil encontrar e modificar configurações  
✅ **Reutilização**: Variáveis e outputs podem ser compartilhados  
✅ **Colaboração**: Múltiplos desenvolvedores podem trabalhar simultaneamente  
✅ **Legibilidade**: Código mais limpo e compreensível

## ⚠️ Backend Remoto S3 (Opcional mas Recomendado)

Para projetos em equipe ou ambientes de produção, é **altamente recomendado** usar backend remoto S3.

### Por que Usar Backend Remoto?

- ✅ **Colaboração**: Múltiplos desenvolvedores compartilham o mesmo estado
- ✅ **State Locking**: Previne conflitos e corrupção do state
- ✅ **Backup Automático**: Versionamento integrado do S3
- ✅ **Segurança**: State armazenado de forma centralizada e segura

### Configurar Backend S3 (Opcional)

Se você quiser usar backend remoto, siga estes passos:

#### 1. Criar Bucket S3 Único

```bash
# Gerar nome único usando timestamp
BUCKET_NAME="terraform-state-varios-arquivos-$(date +%Y%m%d%H%M%S)"

# Criar bucket na região us-east-1
aws s3api create-bucket \
  --bucket $BUCKET_NAME \
  --region us-east-1

# Habilitar versionamento (recomendado)
aws s3api put-bucket-versioning \
  --bucket $BUCKET_NAME \
  --versioning-configuration Status=Enabled

# Exibir nome do bucket criado
echo "Bucket criado: $BUCKET_NAME"
```

#### 2. Adicionar Backend no providers.tf

Edite `providers.tf` e adicione a configuração do backend:

```hcl
terraform {
  required_version = ">= 1.2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  
  # Adicione esta seção para backend remoto
  backend "s3" {
    bucket = "SEU-BUCKET-UNICO-AQUI"  # ⚠️ ALTERE ESTE VALOR
    key    = "varios-arquivos/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
}
```

#### 3. Inicializar com Backend

```bash
# Se você já tem state local, migre para S3
terraform init -migrate-state

# Ou inicialize diretamente se for novo projeto
terraform init
```

#### 4. Verificar Backend

```bash
# Verificar state no S3
aws s3 ls s3://SEU-BUCKET-UNICO-AQUI/varios-arquivos/

# Ver configuração do backend
cat .terraform/terraform.tfstate
```

> **💡 Nota**: Se você preferir usar state local (para testes), pule esta seção e continue sem backend remoto.

## Estrutura dos Arquivos Neste Projeto

```
.
├── README.md           # Documentação do projeto
├── instancia.tf       # Definição da instância EC2
├── security_group.tf  # Configuração do Security Group (se existir)
├── variables.tf       # Declaração de variáveis de entrada
├── outputs.tf         # ⭐ Definição de outputs (IPs, IDs, etc)
├── providers.tf       # Configuração de providers e versões
└── terraform.tfvars   # Valores das variáveis
```

> **💡 Destaque**: Este projeto utiliza um arquivo **`outputs.tf` separado** para centralizar todos os valores de saída, seguindo as melhores práticas do Terraform.

## Descrição dos Arquivos

### `providers.tf` ou `versions.tf`
Define os providers e versões do Terraform:
```hcl
terraform {
  required_version = ">= 1.2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
```

### `variables.tf`
Declara as variáveis de entrada:
```hcl
variable "aws_region" {
  description = "Região AWS"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Tipo da instância EC2"
  type        = string
  default     = "t2.micro"
}
```

### `main.tf` ou `instancia.tf`
Contém os recursos principais:
```hcl
resource "aws_instance" "servidor_devops" {
  ami           = var.ami_id
  instance_type = var.instance_type
  # ...
}
```

### `outputs.tf` ⭐
**Arquivo dedicado** para definir valores de saída após a criação dos recursos:
```hcl
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
```

**Vantagens de ter `outputs.tf` separado:**
- ✅ Centraliza todas as informações de saída em um único lugar
- ✅ Facilita encontrar quais valores estão disponíveis após o deploy
- ✅ Permite documentar melhor cada output com descrições claras
- ✅ Simplifica a manutenção quando há muitos outputs
- ✅ Segue o padrão da comunidade Terraform

### `terraform.tfvars`
Valores específicos das variáveis:
```hcl
aws_region    = "us-east-1"
instance_type = "t2.micro"
ami_id        = "ami-0c7217cdde317cfec"
```

## Pré-requisitos

1. **Terraform instalado**: Versão >= 1.2.0
   ```bash
   terraform --version
   ```

2. **AWS CLI configurado**: Com credenciais válidas
   ```bash
   aws configure
   ```

3. **Key Pair criado**: Certifique-se de que a chave SSH configurada existe na região AWS especificada

4. **Bucket S3 (opcional)**: Apenas se você configurou backend remoto

## Como Executar

### 1. Inicializar o Terraform

```bash
terraform init
```

Este comando:
- Baixa os providers necessários (AWS)
- Inicializa o backend (local ou S3, se configurado)
- Prepara o diretório de trabalho
- Lê **todos** os arquivos `.tf` do diretório

**Se você configurou backend S3:**
- Conecta ao backend S3
- Baixa o state remoto (se existir)

**⚠️ Possíveis erros com backend S3:**

**Erro: "Error loading state: NoSuchBucket"**
```bash
# Verificar se bucket existe
aws s3 ls s3://SEU-BUCKET-UNICO-AQUI/

# Se não existe, criar
aws s3api create-bucket --bucket SEU-BUCKET-UNICO-AQUI --region us-east-1
```

**Erro: "Error loading state: AccessDenied"**
```bash
# Verificar credenciais AWS
aws sts get-caller-identity
```

### 2. Validar a Configuração

```bash
terraform validate
```

Verifica a sintaxe de **todos** os arquivos `.tf`.

### 3. Formatar o Código

```bash
terraform fmt
```

Formata **todos** os arquivos `.tf` seguindo o padrão de estilo.

### 4. Revisar Variáveis

Verifique os valores em `terraform.tfvars` ou crie o arquivo se não existir:

```bash
cat terraform.tfvars
```

Ou passe variáveis via linha de comando:
```bash
terraform plan -var="instance_type=t2.small" -var="aws_region=us-west-2"
```

### 5. Planejar a Execução

```bash
terraform plan
```

Mostra um preview das mudanças considerando **todos** os arquivos `.tf`.

**Salvar o plano**:
```bash
terraform plan -out=tfplan
```

### 6. Aplicar as Mudanças

```bash
terraform apply
```

Ou com o plano salvo:
```bash
terraform apply tfplan
```

Digite `yes` para confirmar.

### 7. Verificar os Outputs

```bash
terraform output
```

**Outputs disponíveis neste projeto:**
- `instance_public_ip`: IP público da instância EC2
- `instance_id`: ID da instância EC2
- `instance_private_ip`: IP privado da instância EC2
- `security_group_id`: ID do Security Group
- `instance_public_dns`: DNS público da instância EC2

**Ver um output específico:**
```bash
# Ver apenas o IP público
terraform output instance_public_ip

# Ver o DNS público
terraform output instance_public_dns

# Usar output em scripts (formato raw, sem aspas)
terraform output -raw instance_public_ip
```

**Exemplos práticos de uso dos outputs:**

```bash
# Salvar IP em variável
IP=$(terraform output -raw instance_public_ip)

# Conectar via SSH usando o output
ssh -i vockey.pem ubuntu@$(terraform output -raw instance_public_ip)

# Usar DNS público
curl http://$(terraform output -raw instance_public_dns)

# Exportar outputs para JSON (útil para scripts)
terraform output -json > outputs.json

# Exportar output específico para arquivo
terraform output -raw instance_public_ip > ip.txt
```

## Modificar a Infraestrutura

### Alterar Variáveis

**Opção 1**: Editar `terraform.tfvars`
```bash
nano terraform.tfvars
```

**Opção 2**: Passar via linha de comando
```bash
terraform apply -var="instance_type=t2.small"
```

**Opção 3**: Usar arquivo de variáveis customizado
```bash
terraform apply -var-file="producao.tfvars"
```

### Alterar Recursos

1. Edite o arquivo correspondente (ex: `main.tf`)
2. Execute `terraform plan` para revisar
3. Execute `terraform apply` para aplicar

## Verificar Recursos Criados

### Via Terraform

```bash
# Listar todos os recursos
terraform state list

# Ver detalhes de um recurso
terraform state show aws_instance.app_server

# Ver todos os outputs
terraform output
```

### Via AWS CLI

```bash
# Listar instâncias EC2
aws ec2 describe-instances --filters "Name=instance-state-name,Values=running"

# Listar security groups
aws ec2 describe-security-groups
```

## Destruir os Recursos

```bash
terraform destroy
```

Digite `yes` para confirmar.

**Destruir recursos específicos**:
```bash
terraform destroy -target=aws_instance.app_server
```

## Comandos Úteis

```bash
# Ver configuração consolidada de todos os arquivos
terraform show

# Atualizar o estado
terraform refresh

# Ver gráfico de dependências
terraform graph

# Listar providers utilizados
terraform providers

# Verificar formato sem alterar
terraform fmt -check

# Ver onde o state está armazenado
cat .terraform/terraform.tfstate

# Se usando backend S3, listar state remoto
aws s3 ls s3://SEU-BUCKET-UNICO-AQUI/varios-arquivos/
```

## Boas Práticas

### ✅ Fazer

- **Usar arquivo `outputs.tf` separado** para todos os outputs
- Separar recursos por responsabilidade em arquivos diferentes
- Usar nomes descritivos para arquivos (`ec2.tf`, `security_groups.tf`)
- Documentar variáveis com `description`
- **Adicionar descrições claras em todos os outputs**
- Definir valores padrão sensatos em `variables.tf`
- Versionar arquivos `.tf` no Git
- Usar `terraform fmt` antes de commits
- **Usar backend remoto S3 para projetos em equipe**
- **Habilitar versionamento no bucket S3**

### ❌ Evitar

- Colocar outputs misturados com recursos no mesmo arquivo
- Colocar todo código em um único arquivo
- Versionar `terraform.tfstate` ou arquivos com credenciais
- Hardcodar valores que mudam entre ambientes
- Misturar recursos de diferentes responsabilidades
- **Outputs sem descrição**
- **Compartilhar state local entre desenvolvedores**

## Arquivos a Ignorar no Git

Crie `.gitignore` com:

```gitignore
# Terraform
.terraform/
.terraform.lock.hcl
terraform.tfstate        # ⚠️ IMPORTANTE: não versionar state
terraform.tfstate.backup
*.tfvars                 # Se contiver credenciais
tfplan
crash.log
override.tf
override.tf.json

# Backups
*.backup
```

> **💡 Nota**: Mesmo com backend S3, adicione `terraform.tfstate` ao `.gitignore` por segurança.

## Exemplo de Workflow

### Workflow com State Local (Desenvolvimento)

```bash
# 1. Clonar repositório
git clone <repo-url>
cd varios_arquivos

# 2. Criar terraform.tfvars com suas configurações
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars

# 3. Inicializar
terraform init

# 4. Validar e formatar
terraform validate
terraform fmt

# 5. Planejar
terraform plan

# 6. Aplicar
terraform apply

# 7. Verificar outputs
terraform output

# 8. Quando terminar, destruir
terraform destroy
```

### Workflow com Backend S3 (Produção)

```bash
# 1. Criar bucket S3 único
BUCKET_NAME="terraform-state-varios-arquivos-$(date +%Y%m%d%H%M%S)"
aws s3api create-bucket --bucket $BUCKET_NAME --region us-east-1
aws s3api put-bucket-versioning --bucket $BUCKET_NAME --versioning-configuration Status=Enabled

# 2. Atualizar providers.tf com backend S3
nano providers.tf
# Adicione a seção backend "s3" conforme mostrado acima

# 3. Criar terraform.tfvars
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars

# 4. Inicializar com backend S3
terraform init

# 5. Validar e formatar
terraform validate
terraform fmt

# 6. Planejar e salvar
terraform plan -out=tfplan

# 7. Aplicar
terraform apply tfplan

# 8. Verificar outputs
terraform output

# 9. Verificar state no S3
aws s3 ls s3://$BUCKET_NAME/varios-arquivos/

# 10. Quando terminar, destruir
terraform destroy
```

## Troubleshooting

### Erro: "No configuration files"

Certifique-se de estar no diretório correto com arquivos `.tf`:
```bash
ls -la *.tf
```

### Erro: "Required variable not set"

Defina a variável em `terraform.tfvars` ou via `-var`:
```bash
terraform apply -var="nome_variavel=valor"
```

### Migrar de State Local para S3

Se você já tem um state local e quer migrar para S3:

```bash
# 1. Fazer backup do state local
cp terraform.tfstate terraform.tfstate.backup

# 2. Adicionar backend "s3" em providers.tf

# 3. Reinicializar e migrar
terraform init -migrate-state

# 4. Verificar se state foi para S3
aws s3 ls s3://SEU-BUCKET-UNICO-AQUI/varios-arquivos/

# 5. Remover state local (opcional, após confirmar)
rm terraform.tfstate terraform.tfstate.backup
```

### Migrar de S3 para State Local

Se você quer voltar para state local:

```bash
# 1. Remover seção backend "s3" de providers.tf

# 2. Reinicializar
terraform init -migrate-state

# 3. Confirmar migração
ls -la terraform.tfstate
```

### Limpar e Reinicializar

```bash
rm -rf .terraform .terraform.lock.hcl terraform.tfstate*
terraform init
```

## Suporte

- [Documentação Oficial do Terraform](https://www.terraform.io/docs)
- [AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)
- [Backend Configuration](https://www.terraform.io/language/settings/backends/s3)
