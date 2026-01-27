# Ansible Playbook - Configuração de Servidores

Este diretório contém playbooks Ansible para configurar as instâncias EC2 criadas pelo Terraform.

## Pré-requisitos

1. **Ansible instalado**: Versão >= 2.9
   ```bash
   ansible --version
   ```

2. **Python instalado**: Versão >= 3.6
   ```bash
   python3 --version
   ```

3. **Instâncias EC2 criadas**: Execute o Terraform no diretório `../../terraform/duas_instancias` primeiro

4. **Chave SSH**: Arquivo `labsuser.pem` com permissões corretas
   ```bash
   chmod 400 labsuser.pem
   ```

5. **AWS CLI configurado**: Para obter outputs do Terraform
   ```bash
   aws configure
   ```

## Integração com Terraform

Este playbook Ansible é projetado para configurar as instâncias EC2 criadas pelo Terraform no diretório `../../terraform/duas_instancias`.

### Fluxo de Trabalho Completo

```
1. Terraform cria infraestrutura
   └── Outputs: IPs das instâncias
       
2. Atualizar inventory.ini com IPs
   └── Manual ou automaticamente

3. Ansible configura servidores
   └── Usa inventory.ini
```

## Passo a Passo

### 1. Criar Infraestrutura com Terraform

Primeiro, crie as instâncias EC2 usando Terraform:

```bash
# Navegar para o diretório do Terraform
cd ../../terraform/duas_instancias

# Criar bucket S3 único para backend
BUCKET_NAME="devops-terraform-state-$(date +%Y%m%d%H%M%S)"
aws s3api create-bucket --bucket $BUCKET_NAME --region us-east-1
aws s3api put-bucket-versioning --bucket $BUCKET_NAME --versioning-configuration Status=Enabled

# Atualizar provedor.tf com o nome do bucket
sed -i '' "s/devops20240227/$BUCKET_NAME/" provedor.tf

# Inicializar e aplicar Terraform
terraform init
terraform validate
terraform plan
terraform apply

# Verificar outputs
terraform output
```

### 2. Obter IPs das Instâncias do Terraform

**Opção A: Manualmente**

```bash
# No diretório terraform/duas_instancias
terraform output web_server_public_ip
terraform output database_server_public_ip
```

**Opção B: Usando Script (Automatizado)**

```bash
# Salvar IPs em variáveis
WEB_IP=$(cd ../../terraform/duas_instancias && terraform output -raw web_server_public_ip)
DB_IP=$(cd ../../terraform/duas_instancias && terraform output -raw database_server_public_ip)

# Exibir IPs
echo "Servidor Web: $WEB_IP"
echo "Servidor BD: $DB_IP"
```

### 3. Atualizar inventory.ini

Edite o arquivo `inventory.ini` com os IPs obtidos do Terraform:

**Opção A: Manual**

```bash
nano inventory.ini
```

Atualize com os IPs:

```ini
[webservers]
web1 ansible_host=IP_DO_SERVIDOR_WEB ansible_user=ubuntu ansible_ssh_private_key_file=./vockey.pem

[databases]
db1 ansible_host=IP_DO_SERVIDOR_BD ansible_user=ubuntu ansible_ssh_private_key_file=./vockey.pem

[all:vars]
ansible_python_interpreter=/usr/bin/python3
```

**Exemplo:**
```ini
[webservers]
web1 ansible_host=54.123.45.67 ansible_user=ubuntu ansible_ssh_private_key_file=./vockey.pem

[databases]
db1 ansible_host=54.123.45.68 ansible_user=ubuntu ansible_ssh_private_key_file=./vockey.pem
```

**Opção B: Automatizado com Script**

```bash
#!/bin/bash
# Script: update_inventory.sh

# Obter IPs do Terraform
WEB_IP=$(cd ../../terraform/duas_instancias && terraform output -raw web_server_public_ip)
DB_IP=$(cd ../../terraform/duas_instancias && terraform output -raw database_server_public_ip)

# Criar inventory.ini
cat > inventory.ini <<EOF
[webservers]
web1 ansible_host=$WEB_IP ansible_user=ubuntu ansible_ssh_private_key_file=./vockey.pem

[databases]
db1 ansible_host=$DB_IP ansible_user=ubuntu ansible_ssh_private_key_file=./vockey.pem

[all:vars]
ansible_python_interpreter=/usr/bin/python3
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOF

echo "inventory.ini atualizado com sucesso!"
echo "Servidor Web: $WEB_IP"
echo "Servidor BD: $DB_IP"
```

Executar o script:
```bash
chmod +x update_inventory.sh
./update_inventory.sh
```

### 4. Verificar Conectividade

Antes de executar o playbook, verifique se consegue conectar aos servidores:

```bash
# Testar conexão SSH direta
ssh -i vockey.pem ubuntu@IP_DO_SERVIDOR_WEB
ssh -i vockey.pem ubuntu@IP_DO_SERVIDOR_BD

# Testar com Ansible ping
ansible all -i inventory.ini -m ping

# Verificar inventário
ansible-inventory -i inventory.ini --list
```

**Saída esperada do ping:**
```
web1 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
db1 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

### 5. Executar o Playbook Ansible

```bash
# Verificar sintaxe do playbook
ansible-playbook playbook.yml -i inventory.ini --syntax-check

# Executar o playbook
ansible-playbook playbook.yml -i inventory.ini
```

### 6. Verificar Configuração

Após executar o playbook:

```bash
# Verificar serviços instalados no servidor web
ansible webservers -i inventory.ini -m shell -a "systemctl status nginx" -b

# Verificar serviços no servidor de banco de dados
ansible databases -i inventory.ini -m shell -a "systemctl status mysql" -b

# Executar comandos ad-hoc
ansible all -i inventory.ini -m shell -a "uptime"
ansible all -i inventory.ini -m shell -a "df -h"
ansible all -i inventory.ini -m shell -a "free -m"
```

## Estrutura de Arquivos

```
.
├── README.md           # Este arquivo
├── inventory.ini       # Inventário de hosts (atualizar com IPs do Terraform)
├── playbook.yml        # Playbook principal
├── vockey.pem          # Chave SSH (obter da AWS)
└── update_inventory.sh # Script para atualizar inventory (opcional)
```

## Exemplo Completo de Workflow

Script completo para integração Terraform + Ansible:

```bash
#!/bin/bash
# Script: deploy_complete.sh

set -e  # Parar em caso de erro

echo "=== 1. Criando Infraestrutura com Terraform ==="
cd ../../terraform/duas_instancias

# Criar bucket S3 se necessário
BUCKET_NAME="devops-terraform-state-$(date +%Y%m%d%H%M%S)"
echo "Criando bucket S3: $BUCKET_NAME"
aws s3api create-bucket --bucket $BUCKET_NAME --region us-east-1 2>/dev/null || true
aws s3api put-bucket-versioning --bucket $BUCKET_NAME --versioning-configuration Status=Enabled

# Atualizar backend
sed -i '' "s/devops20240227/$BUCKET_NAME/" provedor.tf

# Aplicar Terraform
terraform init
terraform apply -auto-approve

# Aguardar instâncias ficarem prontas
echo "Aguardando instâncias iniciarem..."
sleep 30

echo "=== 2. Obtendo IPs do Terraform ==="
WEB_IP=$(terraform output -raw web_server_public_ip)
DB_IP=$(terraform output -raw database_server_public_ip)

echo "Servidor Web: $WEB_IP"
echo "Servidor BD: $DB_IP"

echo "=== 3. Atualizando Inventory do Ansible ==="
cd ../../ansible

cat > inventory.ini <<EOF
[webservers]
web1 ansible_host=$WEB_IP ansible_user=ubuntu ansible_ssh_private_key_file=./vockey.pem

[databases]
db1 ansible_host=$DB_IP ansible_user=ubuntu ansible_ssh_private_key_file=./vockey.pem

[all:vars]
ansible_python_interpreter=/usr/bin/python3
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOF

echo "=== 4. Testando Conectividade ==="
sleep 10  # Aguardar SSH ficar disponível
ansible all -i inventory.ini -m ping --timeout=60

echo "=== 5. Executando Playbook Ansible ==="
ansible-playbook playbook.yml -i inventory.ini

echo "=== Deploy Completo! ==="
echo "Servidor Web: http://$WEB_IP"
echo "Servidor BD: $DB_IP"
```

Executar:
```bash
chmod +x deploy_complete.sh
./deploy_complete.sh
```

## Comandos Úteis do Ansible

```bash
# Listar hosts no inventário
ansible all -i inventory.ini --list-hosts

# Verificar fatos do sistema
ansible all -i inventory.ini -m setup

# Executar comando em todos os servidores
ansible all -i inventory.ini -m shell -a "hostname"

# Executar comando apenas nos webservers
ansible webservers -i inventory.ini -m shell -a "nginx -v"

# Copiar arquivo para servidores
ansible all -i inventory.ini -m copy -a "src=./arquivo.txt dest=/tmp/"

# Instalar pacote
ansible all -i inventory.ini -m apt -a "name=htop state=present" -b

# Reiniciar serviço
ansible webservers -i inventory.ini -m service -a "name=nginx state=restarted" -b
```

## Troubleshooting

### Erro: "Could not match supplied host pattern"

```bash
# Verificar inventory
cat inventory.ini

# Listar hosts
ansible-inventory -i inventory.ini --list
```

### Erro: "Permission denied (publickey)"

```bash
# Verificar permissões da chave
chmod 400 vockey.pem

# Testar conexão SSH
ssh -i vockey.pem ubuntu@IP_DO_SERVIDOR -v
```

### Erro: "Host key verification failed"

Adicione ao `inventory.ini`:
```ini
[all:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
```

### Erro: "Timeout waiting for host"

```bash
# Verificar se instâncias estão rodando
cd ../../terraform/duas_instancias
terraform show

# Verificar security group permite SSH
aws ec2 describe-security-groups --group-names devops
```

### IPs Mudaram

Se você destruiu e recriou as instâncias:

```bash
# Obter novos IPs
cd ../../terraform/duas_instancias
terraform output

# Atualizar inventory
cd ../../ansible
./update_inventory.sh
```

## Limpar Recursos

Quando terminar, destrua a infraestrutura:

```bash
# Destruir instâncias com Terraform
cd ../../terraform/duas_instancias
terraform destroy

# Deletar bucket S3 (opcional)
aws s3 rm s3://SEU-BUCKET --recursive
aws s3api delete-bucket --bucket SEU-BUCKET --region us-east-1
```

## Boas Práticas

- ✅ Sempre teste conectividade antes de executar playbooks
- ✅ Use `--check` para dry-run antes de aplicar mudanças
- ✅ Versione seus playbooks no Git
- ✅ Não versione `inventory.ini` com IPs (use template)
- ✅ Não versione `vockey.pem` (adicione ao `.gitignore`)
- ✅ Use variáveis para configurações que mudam
- ✅ Documente dependências do Terraform

## Arquivos a Ignorar no Git

Crie `.gitignore`:

```gitignore
# Chaves SSH
*.pem
*.key

# Inventários com IPs reais
inventory.ini

# Logs
*.log

# Arquivos temporários
*.tmp
*.retry
```

## Suporte

- [Documentação do Ansible](https://docs.ansible.com/)
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)
- [Integração Terraform-Ansible](https://www.terraform.io/docs/providers/ansible/index.html)