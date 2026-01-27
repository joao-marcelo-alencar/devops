# Terraform - Duas Instâncias

Este diretório contém arquivos Terraform para provisionar infraestrutura na AWS com múltiplas instâncias EC2.

## ⚠️ Backend Remoto S3 - Configuração Obrigatória

Este projeto utiliza **backend remoto S3** para armazenar o estado do Terraform. Isso permite:
- ✅ Compartilhar o estado entre membros da equipe
- ✅ Prevenir conflitos com state locking
- ✅ Backup automático do estado
- ✅ Versionamento do state

### Passo 1: Criar Bucket S3 Único

Cada projeto precisa de um bucket S3 com **nome único globalmente**. 

**Opção 1: Via AWS CLI**

```bash
# Gerar nome único usando timestamp
BUCKET_NAME="devops-terraform-state-$(date +%Y%m%d%H%M%S)"

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

**Opção 2: Via AWS Console**

1. Acesse [S3 Console](https://s3.console.aws.amazon.com/)
2. Clique em **"Create bucket"**
3. **Bucket name**: `devops-terraform-state-YYYYMMDDHHMMSS` (substitua por timestamp único)
4. **Region**: us-east-1
5. **Block Public Access**: Mantenha todas as opções marcadas
6. **Bucket Versioning**: Enable
7. Clique em **"Create bucket"**

**Sugestões de nomenclatura:**
- `devops-terraform-state-20240315123045`
- `terraform-state-seunome-20240315`
- `devops-projeto-terraform-state-v1`

### Passo 2: Atualizar provedor.tf

Edite o arquivo `provedor.tf` e substitua o nome do bucket:

```bash
nano provedor.tf
```

Localize a seção `backend "s3"` e **atualize o valor de `bucket`**:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  backend "s3" {
    bucket = "SEU-BUCKET-UNICO-AQUI"  # ⚠️ ALTERE ESTE VALOR
    key    = "state"
    region = "us-east-1"
  }

  required_version = ">= 1.2.0"
}
```

**Exemplo:**
```hcl
backend "s3" {
  bucket = "devops-terraform-state-20240315123045"
  key    = "state"
  region = "us-east-1"
}
```

### Passo 3: Inicializar com o Backend

Após criar o bucket e atualizar `provedor.tf`:

```bash
# Inicializar Terraform com backend remoto
terraform init

# Se já existe state local, migre para S3
terraform init -migrate-state
```

O Terraform perguntará se você deseja migrar o state existente. Digite `yes`.

### Verificar Backend Configurado

```bash
# Verificar configuração do backend
terraform show

# Listar objetos no bucket S3
aws s3 ls s3://SEU-BUCKET-UNICO-AQUI/
```

## Recursos que Serão Criados

Este projeto Terraform provisiona:

- **Security Groups**: Grupos de segurança para servidor web e banco de dados
- **Regras de Ingress**: Regras de entrada para SSH e outras portas
- **Instâncias EC2**: Duas instâncias (servidor web e banco de dados)
- **Backend S3**: State armazenado remotamente no S3

> **📝 Nota**: Revise os arquivos `.tf` neste diretório para ver a configuração completa dos recursos.

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

## Estrutura do Projeto

```
.
├── README.md          # Este arquivo
├── *.tf              # Arquivos de configuração Terraform
└── terraform.tfvars  # Variáveis (se existir)
```

## Como Executar

### 1. Inicializar o Terraform

```bash
terraform init
```

Se você já configurou o backend S3 corretamente, este comando:
- Baixa os providers necessários (AWS)
- Conecta ao backend S3
- Baixa o state remoto (se existir)
- Prepara o diretório de trabalho

**⚠️ Possíveis erros:**

**Erro: "Error loading state: NoSuchBucket"**
- Verifique se o bucket existe e se o nome está correto em `provedor.tf`

**Erro: "Error loading state: AccessDenied"**
- Verifique suas credenciais AWS: `aws sts get-caller-identity`

### 2. Validar a Configuração

```bash
terraform validate
```

Verifica se a sintaxe dos arquivos `.tf` está correta.

### 3. Formatar o Código (Opcional)

```bash
terraform fmt
```

Formata automaticamente os arquivos Terraform seguindo o padrão de estilo.

### 4. Planejar a Execução

```bash
terraform plan
```

Mostra um preview das mudanças que serão aplicadas:
- Recursos a serem criados (+)
- Recursos a serem modificados (~)
- Recursos a serem destruídos (-)

**Opcional**: Salvar o plano para execução posterior:
```bash
terraform plan -out=tfplan
```

### 5. Aplicar as Mudanças

```bash
terraform apply
```

Ou, se você salvou o plano:
```bash
terraform apply tfplan
```

Digite `yes` quando solicitado para confirmar a criação dos recursos.

### 6. Visualizar Outputs

Após a aplicação bem-sucedida, visualize as informações dos recursos criados:

```bash
terraform output
```

**Outputs disponíveis:**
- `web_server_public_ip`: IP público do servidor web
- `web_server_id`: ID da instância do servidor web
- `database_server_public_ip`: IP público do servidor de banco de dados
- `database_server_id`: ID da instância do servidor de banco de dados

**Ver um output específico:**
```bash
# Ver apenas o IP do servidor web
terraform output web_server_public_ip

# Ver apenas o IP do servidor de banco de dados
terraform output database_server_public_ip

# Usar output em scripts (sem aspas)
terraform output -raw web_server_public_ip
```

**Exemplo de uso:**
```bash
# Salvar IPs em variáveis
WEB_IP=$(terraform output -raw web_server_public_ip)
DB_IP=$(terraform output -raw database_server_public_ip)

# Conectar ao servidor web via SSH
ssh -i vockey.pem ubuntu@$(terraform output -raw web_server_public_ip)

# Conectar ao servidor de banco de dados via SSH
ssh -i vockey.pem ubuntu@$(terraform output -raw database_server_public_ip)

# Exibir todos os IPs
echo "Servidor Web: $WEB_IP"
echo "Servidor BD: $DB_IP"
```

### 7. Verificar os Recursos Criados

#### Via Terraform

```bash
# Listar recursos gerenciados
terraform state list

# Ver detalhes de um recurso específico
terraform state show <RESOURCE_NAME>

# Ver outputs (se definidos)
terraform output
```

#### Via AWS CLI

```bash
# Listar instâncias EC2
aws ec2 describe-instances --filters "Name=instance-state-name,Values=running"

# Listar security groups
aws ec2 describe-security-groups
```

#### Via AWS Console

Acesse o [AWS Console](https://console.aws.amazon.com/) e navegue até:
- **EC2** → Instances
- **EC2** → Security Groups

## Modificar Recursos

Para modificar recursos existentes:

1. Edite os arquivos `.tf` conforme necessário
2. Execute `terraform plan` para revisar as mudanças
3. Execute `terraform apply` para aplicar as alterações

## Destruir os Recursos

Para remover **todos** os recursos criados:

```bash
terraform destroy
```

Digite `yes` quando solicitado para confirmar a destruição.

**⚠️ Atenção**: Este comando é irreversível e removerá permanentemente todos os recursos gerenciados pelo Terraform neste diretório.

### Destruir Recursos Específicos

Para destruir apenas recursos específicos:

```bash
terraform destroy -target=<RESOURCE_TYPE>.<RESOURCE_NAME>
```

Exemplo:
```bash
terraform destroy -target=aws_instance.app_server
```

## Comandos Úteis

```bash
# Ver a versão do Terraform
terraform version

# Ver o estado atual (agora vem do S3)
terraform show

# Atualizar o estado do S3
terraform refresh

# Importar recursos existentes
terraform import <RESOURCE_TYPE>.<RESOURCE_NAME> <RESOURCE_ID>

# Ver gráfico de dependências
terraform graph | dot -Tpng > graph.png

# Verificar backend configurado
terraform state list

# Ver onde o state está armazenado
cat .terraform/terraform.tfstate
```

## Troubleshooting

### Erro de Backend S3

**Erro: "Failed to get existing workspaces: NoSuchBucket"**

Solução:
```bash
# Verificar se bucket existe
aws s3 ls s3://SEU-BUCKET-UNICO-AQUI/

# Se não existe, criar
aws s3api create-bucket --bucket SEU-BUCKET-UNICO-AQUI --region us-east-1

# Reinicializar
terraform init
```

**Erro: "Error acquiring the state lock"**

Solução:
```bash
# Listar locks ativos
aws dynamodb scan --table-name terraform-lock --region us-east-1

# Forçar unlock (use com cuidado!)
terraform force-unlock <LOCK_ID>
```

### Migrar de State Local para S3

Se você já tem um state local e quer migrar:

```bash
# 1. Fazer backup do state local
cp terraform.tfstate terraform.tfstate.backup

# 2. Atualizar provedor.tf com backend S3

# 3. Reinicializar e migrar
terraform init -migrate-state

# 4. Verificar se state foi para S3
aws s3 ls s3://SEU-BUCKET-UNICO-AQUI/

# 5. Remover state local (opcional, após confirmar)
rm terraform.tfstate terraform.tfstate.backup
```

### Erro de Credenciais AWS

```bash
# Verificar credenciais configuradas
aws sts get-caller-identity

# Reconfigurar credenciais
aws configure
```

### Erro de State Lock

Se o terraform travar com um lock ativo:

```bash
# Ver locks ativos
terraform force-unlock <LOCK_ID>
```

### Limpar Cache e Reinicializar

```bash
rm -rf .terraform .terraform.lock.hcl
terraform init
```

## Boas Práticas

- ✅ Sempre execute `terraform plan` antes de `apply`
- ✅ Use controle de versão (Git) para os arquivos `.tf`
- ✅ **NÃO versione `terraform.tfstate` (agora está no S3)**
- ✅ Use workspaces para ambientes diferentes (dev, staging, prod)
- ✅ Documente variáveis e outputs
- ✅ **Use backend remoto S3 para trabalho em equipe**
- ✅ **Habilite versionamento no bucket S3**
- ✅ **Use nomes de bucket únicos e descritivos**
- ✅ Faça backup do state antes de mudanças críticas

## Arquivos a Ignorar no Git

Adicione ao `.gitignore`:

```gitignore
# Terraform
.terraform/
.terraform.lock.hcl
terraform.tfstate        # ⚠️ IMPORTANTE: não versionar state local
terraform.tfstate.backup
*.tfvars                 # Se contiver credenciais
tfplan

# Backups
*.backup
```

> **💡 Nota**: Com backend S3, o `terraform.tfstate` não deve existir localmente, mas adicione ao `.gitignore` por segurança.

## Exemplo de Workflow Completo

```bash
# 1. Criar bucket S3 único
BUCKET_NAME="devops-terraform-state-$(date +%Y%m%d%H%M%S)"
aws s3api create-bucket --bucket $BUCKET_NAME --region us-east-1
aws s3api put-bucket-versioning --bucket $BUCKET_NAME --versioning-configuration Status=Enabled

# 2. Atualizar provedor.tf com o nome do bucket
sed -i '' "s/devops20240227/$BUCKET_NAME/" provedor.tf

# 3. Inicializar com backend S3
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

# 8. Verificar state no S3
aws s3 ls s3://$BUCKET_NAME/

# 9. Quando terminar, destruir
terraform destroy
```

## Suporte

Para mais informações, consulte a [documentação oficial do Terraform](https://www.terraform.io/docs).
