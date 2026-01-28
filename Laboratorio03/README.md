# LABORATÓRIO 3

**CH:** 2 horas  
**Plataforma:** Via Zoom

**CONTEÚDO PROGRAMÁTICO:**
Este laboratório abordará os conceitos fundamentais de controle de versão, com foco no sistema Git. Os tópicos incluem a diferenciação entre repositórios centralizados e distribuídos, a arquitetura do Git, o fluxo de trabalho.

**OBJETIVOS DA APRENDIZAGEM:**
* Compreender o conceito e a importância dos sistemas de controle de versão (SCM) para o desenvolvimento de software.
* Diferenciar os modelos de controle de versão centralizado e distribuído.
* Realizar operações básicas do Git, como `clone`, `add`, `commit`, `push` e `pull`.
* Aplicar o conceito de branches para gerenciar o desenvolvimento de funcionalidades de forma isolada.
* Utilizar tags para rotular versões de código.
* Colaborar em um projeto utilizando o fluxo de pull request no GitHub.

## ROTEIRO DE ATIVIDADES

| Atividade | Descrição | Duração |
| :--- | :--- | :--- |
| **Atividade 1:** | Preparar o ambiente de trabalho e familiarizar-se com a criação de um repositório Git localmente. | 15 min. |
| **Atividade 2:** | Explorando o Fluxo de Trabalho com Branches. | 45 min. |
| **Atividade 3:** | Sincronização com o Repositório Remoto. | 25 min. |
| **INTERVALO** | --- | 10 min. |
| **Atividade 4:** | Uso de Pull Requests e Tags. | 20 min. |
| **Fechamento da aula** | --- | 5 min |

---

# Laboratório 3

### Atividade 1 (15 min.)

Considerando que você está com a ferramenta de linha de comando `git` instalada na sua máquina, realize as seguintes atividades na sua máquina local:

* **Criação de Diretório:** Crie um novo diretório _lab03_ para o projeto em sua máquina local.
* **Inicialização do Repositório:** Dentro do novo diretório, inicialize um repositório Git usando o comando `git init`.
    * Este comando cria uma pasta oculta `.git` que armazena o histórico do projeto.
* **Configuração de Identidade:** Configure seu nome de usuário e e-mail no Git para que seus commits sejam identificados corretamente.
    ```bash
    git config user.name "Seu Nome "
    git config user.email "seu.email@exemplo.com"
    ```
* **Criação do Primeiro Arquivo:** Crie um arquivo README.md com seu nome e e-mail.
    * Adicione-o ao `stage` e faça seu primeiro _commit_.

Não vamos adicionar uma origem remota agora, primeiro vamos praticar na cópia local.

### Atividade 2 (45 min.)

Nesta atividade vamos praticar a criação, navegação e fusão de _branches_ para o desenvolvimento de uma nova funcionalidade.

* **Criação de um Branch de Funcionalidade:** 
    * Crie um novo branch chamado `feature-cadastro` para simular o desenvolvimento de uma funcionalidade de cadastro de usuários.
    * Mude para este novo _branch_ com o comando `git checkout`.
* **Desenvolvimento da Funcionalidade:** 
    * Crie um novo arquivo, como `usuarios.py`, e adicione um código de exemplo para o cadastro.
* **Commits na Feature:** Adicione e faça um ou mais _commits_ para registrar suas alterações no branch `feature-cadastro`.
    * Lembre-se de usar mensagens de _commit_ descritivas.
* **Integração com o Branch Principal:** 
    * Mude de volta para o _branch main_ (ou _master_).
    * Realize a fusão (_merge_) do _branch_ `feature-cadastro` no branch principal.
    * Isso irá incorporar o novo código ao projeto principal.
* **Simulando um Conflito:** 
    * Crie uma alteração no mesmo arquivo no _branch_ principal e faça o _commit_ das mudanças.
    * Em seguida, volte para o _branch_ da sua _feature_, faça uma pequena alteração no mesmo arquivo, realize o _commit_ e tente fazer o _merge_ novamente retornando para _main_.
    * Observe como o Git sinaliza o conflito e pratique a resolução manual.

O código inserido pode ser qualquer texto mesmo, o importante é verificar como Git lida com conflitos entre os _branches_.

### Atividade 3 (30 min.)

Agora sim vamos conectar repositório local a um repositório remoto no GitHub e sincronizar o trabalho.

* **Criação de Repositório Remoto:** 
    * No GitHub, crie um novo repositório público vazio (sem README.md inicial).
    * Pode usar qualquer nome ou “lab03”.
* **Vincular Repositórios:** Vincule o repositório local que você criou com o novo repositório no GitHub, usando o comando:
    ```bash
    git remote add origin <URL_do_repositório>
    ```
* **Envio de Alterações (Push):** Envie seu _branch_ principal para o repositório remoto usando (será necessário usar as credenciais):
    ```bash
    git push -u origin main
    ```
* **Criação de um Novo Branch Remoto:** Envie o novo _branch_ local para o GitHub com:
    ```bash
    git checkout feature-cadastro
    git push --set-upstream origin feature-cadastro
    ```
* **Simulando Colaboração:** 
    * Edite um arquivo diretamente na interface web do GitHub para simular uma alteração feita por outro colaborador.
    * Em seguida, utilize o comando `git pull` para buscar e integrar essas alterações em sua máquina local.
    * Você precisa estar no _branch_ da alteração para observar as mudanças.

Veja que utilizamos o nome `origin` para representar a origem remota do GitHub. Mas podemos ter mais de uma origem remota, com nomes diferentes e acrescentar aos comandos `git push` ou `git pull` o nome a origem a ser usada.

### Atividade 4 (40 min.)

Para complementar o conteúdo das aulas, vamos compreender e praticar o fluxo de trabalho de _pull requests_ e o uso de _tags_ para versionamento.

* **Criação de um Pull Request:**
    * Crie um novo _branch_ para uma pequena correção de _bug_, como `bugfix-css`.
    * Faça uma alteração no código e um _commit_.
    * Envie o novo _branch_ para o GitHub.
    * Acesse a interface do GitHub e crie um _pull request_ do seu branch `bugfix-css` para o `main`.
    * Observe a interface de revisão de código do GitHub.
* **Aplicação de Tags:** 
    * Crie uma tag para rotular uma versão estável do projeto, por exemplo, v1.0.0.
     ```bash
    git tag -a v1.0.0 -m "Primeira tag."
    ```
    * Envie a _tag_ para o repositório remoto com:
    ```bash
    git push origin v1.0.0
    ```