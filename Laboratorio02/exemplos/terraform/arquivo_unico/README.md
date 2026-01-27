# Descrição do Terraform main.tf

Este arquivo Terraform provisiona uma infraestrutura básica na AWS com os seguintes componentes:

## Configuração do Terraform

- **Provider**: AWS (versão ~> 4.16)
- **Região**: us-east-1
- **Versão mínima do Terraform**: >= 1.2.0

## Recursos Criados

### 1. Security Group (Grupo de Segurança)
- **Nome**: `devops`
- **Descrição**: Grupo de Segurança da Disciplina DevOps
- **Tag**: Name = "devops"

### 2. Regra de Ingress (Entrada)
- **Tipo**: Permitir tráfego SSH
- **Protocolo**: TCP
- **Porta**: 22
- **Origem**: 0.0.0.0/0 (qualquer endereço IPv4)
- **Associado ao**: Security group `devops`

### 3. Instância EC2
- **Nome**: InstanciaDevOps
- **AMI**: ami-0c7217cdde317cfec (Ubuntu)
- **Tipo de Instância**: t2.micro
- **Key Pair**: vockey
- **Security Group**: devops

> **⚠️ Atenção**: A AMI `ami-0c7217cdde317cfec` pode estar desatualizada ou não estar disponível em sua conta/região AWS. Verifique e atualize o ID da AMI conforme necessário para sua região antes de executar o Terraform.

## Como Criar os Recursos

### Pré-requisitos

1. **Terraform instalado**: Versão >= 1.2.0
   ```bash
   terraform --version
   ```

2. **AWS CLI configurado**: Com credenciais válidas
   ```bash
   aws configure
   ```

3. **Key Pair criado**: Certifique-se de que a chave `vockey` existe na região us-east-1, ou altere o valor de `key_name` no arquivo `main.tf`

### Passo a Passo

#### 1. Inicializar o Terraform
```bash
terraform init
```
Este comando baixa os providers necessários (AWS) e inicializa o diretório de trabalho.

#### 2. Validar a Configuração
```bash
terraform validate
```
Verifica se a sintaxe do arquivo está correta.

#### 3. Planejar a Execução
```bash
terraform plan
```
Mostra quais recursos serão criados, modificados ou destruídos, sem aplicar as mudanças.

#### 4. Aplicar as Mudanças
```bash
terraform apply
```
Cria os recursos na AWS. Digite `yes` quando solicitado para confirmar.

#### 5. Visualizar Outputs

Após a aplicação bem-sucedida, visualize as informações dos recursos criados:

```bash
terraform output
```

**Outputs disponíveis:**
- `instance_public_ip`: IP público da instância EC2
- `instance_id`: ID da instância EC2
- `security_group_id`: ID do Security Group

**Ver um output específico:**
```bash
# Ver apenas o IP público
terraform output instance_public_ip

# Usar output em scripts (sem aspas)
terraform output -raw instance_public_ip
```

**Exemplo de uso:**
```bash
# Salvar IP em variável
IP=$(terraform output -raw instance_public_ip)

# Conectar via SSH usando o output
ssh -i vockey.pem ubuntu@$(terraform output -raw instance_public_ip)
```

#### 6. Verificar os Recursos Criados
Após a aplicação bem-sucedida, você pode verificar os recursos:

**No AWS Console:**
- Acesse EC2 Dashboard
- Verifique a instância "InstanciaDevOps"
- Verifique o Security Group "devops"

**Via AWS CLI:**
```bash
# Listar instâncias EC2
aws ec2 describe-instances --filters "Name=tag:Name,Values=InstanciaDevOps"

# Listar security groups
aws ec2 describe-security-groups --filters "Name=group-name,Values=devops"
```

### Conectar à Instância

Após a criação, conecte-se via SSH:

```bash
ssh -i ~/labsuser.pem ubuntu@<IP_PUBLICO_DA_INSTANCIA>
```

> Substitua `<IP_PUBLICO_DA_INSTANCIA>` pelo endereço IP público da instância criada.

### Destruir os Recursos

Para remover todos os recursos criados:

```bash
terraform destroy
```
Digite `yes` quando solicitado para confirmar a destruição.

## Resumo

Este código cria uma instância EC2 do tipo t2.micro na região us-east-1, protegida por um grupo de segurança que permite acesso SSH (porta 22) de qualquer origem. A instância utiliza a chave SSH `vockey` para autenticação.