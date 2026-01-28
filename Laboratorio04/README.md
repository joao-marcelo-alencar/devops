# LABORATÓRIO 4 – Prática Avaliada 01

**CH:** 2 horas  
**Plataforma:** Via Zoom

**CONTEÚDO PROGRAMÁTICO:**
* Conceitos de Infraestrutura como Código (IaC), provisionamento e configuração de servidores.
* Uso de Git para versionamento e colaboração em equipe.
* Utilização de Terraform para descrever e provisionar recursos de nuvem, como instâncias EC2.
* Uso de Ansible para configurar o software em servidores provisionados.
* Sincronização de repositórios locais e remotos no GitHub.
* Uso de branches para o desenvolvimento de funcionalidades e a resolução de conflitos de merge.

**OBJETIVOS DA APRENDIZAGEM:**
Este Laboratório e Prática Avaliada tem como objetivo simular um fluxo de trabalho real de desenvolvimento e infraestrutura, combinando as ferramentas Git para controle de versão, Terraform para provisionamento de recursos na nuvem e Ansible para a configuração desses recursos. Você praticará o desenvolvimento colaborativo, a criação de infraestrutura e a automação de configurações, elementos essenciais no fluxo de valor tecnológico.

## ROTEIRO DE ATIVIDADES

| Atividade | Descrição | Duração |
| :--- | :--- | :--- |
| **Atividade 1:** | Preparação do Ambiente e Repositório. | 20 min. |
| **Atividade 2:** | Provisionamento da Infraestrutura com Terraform | 30 min. |
| **INTERVALO** | --- | 10 min. |
| **Atividade 3:** | Configuração da Infraestrutura com Ansible | 40 min. |
| **Atividade 4:** | Integração do Fluxo de Trabalho | 15 min. |
| **Fechamento da aula** | --- | 5 min |

---

# Laboratório 4 - Prática Avaliada

Ao final de todas as atividades, envie a URL do repositório criado ao Tutor.

### Atividade 1 (20 min.) – 2,0 pontos

Nesta atividade, você vai configurar seu ambiente de trabalho e um repositório Git local para hospedar os arquivos de IaC.

* Crie um novo diretório chamado `iac_lab` e, dentro dele, inicialize um repositório Git vazio com o comando `git init`.
* Configure seu nome de usuário e e-mail no Git.
* Crie um arquivo README.md com o título do laboratório e uma breve descrição.
* Adicione o arquivo ao `stage` e faça seu primeiro `commit`.
* No GitHub, crie um **novo repositório público vazio** (sem README.md inicial).
* Vincule seu repositório local ao repositório remoto no GitHub usando `git remote add origin <URL_do_repositório>`.
* Envie suas alterações para o repositório remoto com `git push -u origin main`

Esta atividade é para ser feita sem dificuldade, pois já foi praticada em laboratório anterior.

**Prova de Conclusão:** Envie para o avaliador uma captura de tela do seu terminal mostrando os comandos de `git init`, `git remote add` e `git push`.
Os comandos precisam executar com sucesso.

### Atividade 2 (30 min.) – 2,0 pontos

Nesta atividade, você usará o Terraform para provisionar uma máquina virtual (instância EC2) na AWS.

* Crie um novo `branch` chamado `terraform-setup` para trabalhar na infraestrutura.
* No diretório `iac_lab`, crie um arquivo chamado `main.tf` com o código Terraform necessário para provisionar uma instância EC2 de sua escolha (por exemplo, t2.micro executando Ubuntu Linux).
* Inclua a configuração de um grupo de segurança que permita acesso SSH (porta 22).
* Execute `terraform init` para inicializar o diretório de trabalho do Terraform.
* Execute `terraform plan` para gerar um plano de execução e visualizar os recursos que serão criados.
* Execute `terraform apply` e confirme para criar a infraestrutura na AWS.
* Adicione e faça o `commit` dos arquivos .tf no seu `branch` `terraform-setup` e envie o `branch` para o GitHub.

**Prova de Conclusão:** Envie para o avaliador uma captura de tela do seu terminal mostrando os comandos `terraform plan` e `terraform apply`.
No último caso, pela saída ser muito longa, você pode capturar apenas o final mostrando que ocorreu com sucesso.

### Atividade 3 (40 min.) – 3,0 pontos

Agora, você usará o Ansible para configurar a instância que você acabou de provisionar com o Terraform.

* No `branch terraform-setup`, crie um arquivo de inventário estático para o Ansible.
* O arquivo deve conter o IP público da instância EC2 que você provisionou, além do usuário (ubuntu) e indiciar o caminho para a chave privada para acesso SSH `labsuser.pem`. Não adicione o arquivo de chave no repositório!
* Crie um `playbook` Ansible (playbook.yml) para realizar as seguintes tarefas na sua instância:
    * Instalar o servidor `web` NGINX.
    * Iniciar o serviço do NGINX.
* Execute o `playbook` usando o comando `ansible-playbook -i <arquivo_do_inventário> playbook.yml`.
* Acesse o IP público da sua instância em um navegador `web` para verificar se o NGINX foi instalado e está rodando.
* Adicione e faça o `commit` do seu arquivo de inventário e do `playbook` Ansible no `branch terraform-setup`.

**Prova de Conclusão:** Envie para o avaliador uma captura de tela do seu terminal mostrando a saída do comando `ansible-playbook` e uma captura de tela do navegador mostrando a página inicial do NGINX na URL da sua instância.
A saída do `ansible-playbook` pode ser as últimas linhas apenas.

### Atividade 4 (40 min.) – 3,0 pontos

Nesta etapa final, você integrará suas alterações ao `branch` principal e removerá os recursos criados para evitar cobranças.

* Acesse a interface `web` do GitHub e crie um `Pull Request` para mesclar o branch `terraform-setup` no `branch main`.
* No GitHub, realize o merge do `Pull Request`.
* Volte ao seu terminal, mude para o `branch main` e execute `git pull` para sincronizar as alterações do repositório remoto.
* Por fim, execute `terraform destroy` para remover todos os recursos criados na AWS e evitar custos.
* Adicione e faça o `commit` das últimas alterações no `branch main` e envie para o repositório remoto.

**Prova de Conclusão:** Envie uma captura de tela do `Pull Request` no GitHub e uma captura de tela do seu terminal mostrando a saída do comando `terraform destroy`.