# LABORATÓRIO 2 

**CH:** 2 horas   
**Plataforma:** Via Zoom 

**CONTEÚDO PROGRAMÁTICO:** 
* Uso do Terraform para criação de recursos na nuvem. 
* Uso do Ansible para configuração de recursos na nuvem. 

**OBJETIVOS DA APRENDIZAGEM:** 
* Expandir o Terraform para criar novos recursos na nuvem. 
* Expandir o Ansible para configurar o uso dos novos recursos na nuvem. 

## ROTEIRO DE ATIVIDADES 

| Atividade | Descrição | Duração |
| :--- | :--- | :--- |
| **Atividade 1:** | Apresentar os objetivos do Momento Síncrono. | 10 min.  |
| **Atividade 2:** | Instalar e configurar o Terraform e Ansible na máquina local. | 10 min.  |
| **Atividade 3:** | Definir um arquivo Terraform para criar instâncias EC2 e RDS. | 40 min.  |
| **INTERVALO** | --- | 10 min.  |
| **Atividade 4:** | Definir um playbook Ansible para criar uma tabela no banco da instância RDS. | 40 min.  |
| **Atividade 5:** | Remover os recursos de forma segura para evitar cobrança de créditos no AWS Academy. | 5 min.  |
| **Fechamento da aula** | --- | 5 min  |

---

# Laboratório 2 

> **Nota para o Tutor:** indicar a pasta com os exemplos. 

### Atividade 1 (10 min.) 

O objetivo geral deste laboratório é praticar os conhecimentos sobre as ferramentas de infraestrutura como código. Os objetivos específicos seriam: 

* Relembrar as bases de IaC (apresentadas em aula) e aplicá-las no provisionamento na nuvem. 
* Expandir o Terraform para criar e configurar múltiplos recursos na AWS (EC2 + RDS). 
* Aplicar _playbooks_ Ansible para instalar dependências e interagir com o banco de dados. 
* Compreender a importância da integração entre diferentes ferramentas de IaC. 
* Desenvolver boas práticas de automação: versionamento, modularização e reuso de código. 

O conhecimento praticado será importante para as etapas posteriores da disciplina. Portanto, para esta atividade, revise o conteúdo da pasta exemplo no repositório.

### Atividade 2 (10 min.) 

Instale o Terraform e o Ansible na sua máquina local. 
Você pode utilizar os _scripts_ no repositório da disciplina ou fazer uma instalação personalizada de acordo com sua instalação de Linux. 
Para comprovar a instalação, recupere as credenciais do AWS Academy e execute os exemplos apresentados em aula. 
Verifique se o servidor _web_ foi carregado para comprar o sucesso da instalação. 

**Referências:** 
* https://medium.com/@sriniv.v29/terraform-introduction-and-installation-on-linux-ubuntu-debian-31486f51fb04 
* https://snapshooter.com/learn/linux/install-and-use-terraform 
* https://www.cherryservers.com/blog/install-ansible-ubuntu-24-04 
* https://blog.cloudmylab.com/ansible-setup-step-by-step 

### Atividade 3 (40 min.) 

A partir dos exemplos em sala de aula, você irá criar um novo arquivo Terraform que cria os recursos principais: 

* Uma instância EC2, de qualquer tipo, mas executando Ubuntu Linux. 
* Uma instância RDS usando como base o PostgreSQL, com a menor capacidade possível, apenas o suficiente para executar o banco. 
* Configurações de grupo de segurança adequadas. 

Depois, execute o arquivo e verifique pelo console web da AWS se os recursos foram criados. 

**Referências:** 
* https://spacelift.io/blog/terraform-aws-rds 
* https://developer.hashicorp.com/terraform/tutorials/aws/aws-rds 

### Atividade 4 (40 min.) 

Crie um _playbook_ Ansible para realizar as seguintes tarefas: 

* Instalar o cliente PostgreSQL na instância criada. 
* Configurar a conexão com o banco RDS. 
* Executar um comando que crie um banco chamado `devops`. 

Não é necessário criar nenhuma tabela no banco. O importante é apenas confirmar que a instância consegue acessar o banco. 

**Referências:** 
* https://docs.ansible.com/ansible/latest/collections/ansible/builtin/apt_module.html 
* https://stackoverflow.com/questions/45457694/ansible-postgresql-module-to-create-role-and-add-database 

### Atividade 5 (5 min.) 

Remova todos os recursos criados usando o Terraform. O objetivo é economizar créditos da AWS Academy. 