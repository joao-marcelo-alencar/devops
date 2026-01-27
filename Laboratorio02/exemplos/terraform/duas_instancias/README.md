# Terraform - Duas Instâncias

Este diretório contém arquivos Terraform para provisionar infraestrutura na AWS.

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

Este comando:
- Baixa os providers necessários (AWS)
- Inicializa o backend
- Prepara o diretório de trabalho

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

# Ver o estado atual
terraform show

# Atualizar o estado
terraform refresh

# Importar recursos existentes
terraform import <RESOURCE_TYPE>.<RESOURCE_NAME> <RESOURCE_ID>

# Ver gráfico de dependências
terraform graph | dot -Tpng > graph.png
```

## Troubleshooting

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
- ✅ Não versione arquivos sensíveis (`terraform.tfstate`, `*.tfvars` com credenciais)
- ✅ Use workspaces para ambientes diferentes (dev, staging, prod)
- ✅ Documente variáveis e outputs
- ✅ Use remote state para trabalho em equipe

## Arquivos a Ignorar no Git

Adicione ao `.gitignore`:

```gitignore
# Terraform
.terraform/
.terraform.lock.hcl
terraform.tfstate
terraform.tfstate.backup
*.tfvars
tfplan
```

## Suporte

Para mais informações, consulte a [documentação oficial do Terraform](https://www.terraform.io/docs).
