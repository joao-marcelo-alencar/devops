# Laboratório 1

**Carga Horária:** 2 horas  
**Plataforma:** Via Zoom  
**Conteúdo Programático:** 
- Uso da Nuvem
- Ambiente Linux

---

## Objetivos da Aprendizagem

Uma vez que os alunos já devem ter um ambiente Linux configurado de acordo com os Exercícios Práticos, este momento síncrono tem como objetivos:

* Garantir que o acesso à nuvem está configurado.
* Acessar máquina virtual na nuvem através do protocolo SSH.
* Revisar o básico de Linux no terminal.

> **Nota:** O conteúdo dos objetivos é assunto da disciplina de Computação em Nuvem. Este laboratório serve como revisão e nivelamento necessário para a disciplina de DevOps.

---

## Roteiro de Atividades

| Atividade | Descrição | Duração |
| :--- | :--- | :--- |
| **Atividade 1** | Apresentar os objetivos do Momento Síncrono. | 10 min. |
| **Atividade 2** | Acesso ao Laboratório de Aprendizado na AWS Academy. | 15 min. |
| **Atividade 3** | Configuração da linha de comando AWS. | 30 min. |
| **Intervalo** | --- | 10 min. |
| **Atividade 4** | Criação de uma Máquina Virtual Linux. | 30 min. |
| **Atividade 5** | Configuração do Ambiente Linux de cada aluno para conexão SSH. | 20 min. |
| **Fechamento** | Encerramento da aula. | 5 min. |

---

## Detalhamento das Atividades

### Atividade 1 (10 min.)

A atividade 1 tem como finalidade apresentar e explicar os objetivos do momento síncrono. Uma vez que os alunos já devem ter um ambiente Linux configurado de acordo com os Exercícios Práticos, este momento síncrono tem três objetivos: 

* Garantir que o acesso à nuvem está configurado.
* Acessar máquina virtual na nuvem através do protocolo SSH.
* Revisar o básico de Linux no terminal:
    * Listar o conteúdo de diretórios.
    * Criar, copiar, mover e excluir diretórios e arquivos.
    * Editar arquivos de texto.
    * Permissões.
     
Podemos afirmar que o conteúdo dos objetivos é assunto da disciplina de Computação em Nuvem. Então outra maneira de enxergar este laboratório seria uma revisão e nivelamento de Computação em Nuvem necessário para a disciplina de DevOps.

### Atividade 2 (15 min.)
O aluno deve acessar o **AWS Academy**, inicializar o *Laboratório de Aprendizado* e acessar o console web da AWS.

### Atividade 3 (30 min.)
O aluno deve instalar as ferramentas de linha de comando da AWS em seu ambiente Linux local.

* **Instruções de instalação:** [Guia oficial da AWS CLI](https://docs.aws.amazon.com/pt_br/cli/latest/userguide/getting-started-install.html).

Antes de seguir os passos do guia oficial da AWS, pode ser necessário instalar alguns pacotes:

```bash
sudo apt-get install curl unzip less ssh
```

Se sua versão do Ubuntu for a _desktop_, é provável que esses pacotes já estejam instalados.

Após a instalação, recupere as credenciais disponíveis na seção **AWS Details** do AWS Academy e configure sua instalação local:

1.  Execute o comando de configuração:
    ```bash
    aws configure
    ```
2.  Copie o conteúdo de *AWS Details* para o arquivo de credenciais (geralmente em `~/.aws/credentials`).
3.  Valide a instalação executando:
    ```bash
    aws ec2 describe-instances
    ```

### Atividade 4 (30 min.)

Utilize o console da AWS para criar uma máquina virtual com as seguintes especificações:
* **Tipo:** `t2.micro`
* **Sistema Operacional:** Ubuntu Server Linux 24.04
* **Grupo de Segurança:** Garanta que a porta 22/tcp está liberada.
* **Arquitetura:** x86
* **Armazenamento:** 60 GB

Após a criação, verifique a existência da nova máquina via terminal local:
```bash
aws ec2 describe-instances
```

### Atividade 5 (20 min.)

Realize o login via SSH na instância da nuvem a partir do seu ambiente Linux local.

Baixe o arquivo labsuser.pem disponível na seção AWS Details.

Ajuste as permissões do arquivo de chave (passo essencial para garantir o acesso):

```bash
chmod 0600 labsuser.pem
```

Utilize o arquivo para autenticação ao conectar na instância.
