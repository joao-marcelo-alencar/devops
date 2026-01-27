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

Se você quiser usar backend remoto, siga estes passos. Caso você tenha executado o exemplo anterior de duas instâncias, pode reutilizar o _bucket_.

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
ssh -i labsuser.pem ubuntu@$(terraform output -raw instance_public_ip)

# Usar DNS público
curl http://$(terraform output -raw instance_public_dns)

# Exportar outputs para JSON (útil para scripts)
terraform output -json > outputs.json

# Exportar output específico para arquivo
terraform output -raw instance_public_ip > ip.txt
```

