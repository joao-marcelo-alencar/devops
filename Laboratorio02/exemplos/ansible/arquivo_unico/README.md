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

4. **Chave SSH**: Arquivo `labsuser.pem` com permissões corretas no seu diretório de usuário:

   ```bash
   chmod 400 ~/labsuser.pem
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

# Criar bucket S3 único para backend - Somente se já não tiver executado antes
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

```bash
nano inventory.ini
```

Atualize com os IPs:

```ini
[webservers]
web1 ansible_host=IP_DO_SERVIDOR_WEB ...

[databases]
db1 ansible_host=IP_DO_SERVIDOR_BD ...
```

### 4. Verificar Conectividade

Antes de executar o playbook, verifique se consegue conectar aos servidores:

```bash
# Testar conexão SSH direta
ssh -i ~/labsuser.pem ubuntu@IP_DO_SERVIDOR_WEB
ssh -i ~/labsuser.pem ubuntu@IP_DO_SERVIDOR_BD

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
└── update_inventory.sh # Script para atualizar inventory (opcional)
```

## Suporte

- [Documentação do Ansible](https://docs.ansible.com/)
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)
- [Integração Terraform-Ansible](https://www.terraform.io/docs/providers/ansible/index.html)