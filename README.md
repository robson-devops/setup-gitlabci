# 🚀 Instalação Automatizada do GitLab CE

Este projeto contém um script Bash para instalação automática do GitLab
Community Edition (CE) em sistemas baseados em Debian/Ubuntu.

O script:

-   Atualiza os repositórios
-   Instala dependências necessárias
-   Adiciona o repositório oficial do GitLab
-   Instala o GitLab CE
-   Configura automaticamente o `external_url`
-   Executa o `gitlab-ctl reconfigure`

------------------------------------------------------------------------

## 📋 Pré-requisitos

-   Sistema baseado em Ubuntu/Debian
-   Acesso root ou sudo
-   Porta 80 liberada
-   Mínimo recomendado:
    -   4GB RAM
    -   2 vCPUs

----------------------------------------------------------------------

## 🔧 Como Usar

### 1️⃣ Dê permissão de execução ao script

```bash
chmod +x setup_gitlabci.sh
```
------------------------------------------------------------------------

### 2️⃣ Execute como root ou com sudo

Você pode executar de duas formas:

### ✔️ Usando o IP automático da máquina

```bash
sudo ./setup_gitlabci.sh
```

O script irá detectar automaticamente o IP local da máquina.

------------------------------------------------------------------------

### ✔️ Informando um IP ou domínio manualmente

```bash
sudo ./setup_gitlabci.sh 192.168.0.10
```
ou

```bash
sudo ./setup_gitlabci.sh gitlab.seudominio.com
```
------------------------------------------------------------------------

## ⚙️ O Que o Script Faz

### 🔹 1. Atualiza o sistema

```bash
sudo apt-get update
```

### 🔹 2. Instala dependências

-   curl
-   openssh-server
-   ca-certificates
-   tzdata
-   perl
-   postfix

### 🔹 3. Adiciona repositório oficial do GitLab

```bash
curl -sS
https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh
\| sudo bash
```

### 🔹 4. Instala o GitLab CE

```bash
sudo apt-get install gitlab-ce -y
```

### 🔹 5. Configura o external_url

O script altera automaticamente:

external_url 'http://gitlab.example.com'

para:

external_url 'http://SEU_IP_OU_DOMINIO'

Arquivo alterado:

/etc/gitlab/gitlab.rb

------------------------------------------------------------------------

### 🔹 6. Executa o reconfigure

```bash
sudo gitlab-ctl reconfigure
```
------------------------------------------------------------------------

## 🌐 Acesso ao GitLab

Após a instalação bem-sucedida, acesse:

http://SEU_IP_OU_DOMINIO

------------------------------------------------------------------------

## 🔑 Senha Inicial do Root

Para visualizar a senha inicial:

sudo cat /etc/gitlab/initial_root_password

⚠️ Essa senha é gerada automaticamente e armazenada temporariamente.

------------------------------------------------------------------------

## 🛑 Possíveis Problemas

### ❌ Erro ao executar o script

Certifique-se de que está rodando como root:

```bash
sudo ./install_gitlab.sh
```
------------------------------------------------------------------------

### ❌ Porta 80 ocupada

Verifique:
```bash
sudo lsof -i :80
```
------------------------------------------------------------------------

### ❌ Falha no reconfigure

Verifique logs:
```bash
sudo gitlab-ctl status sudo gitlab-ctl tail
```

------------------------------------------------------------------------

## 🔒 Segurança (Recomendado para Produção)

Este script instala usando HTTP.

Para ambiente produtivo recomenda-se:

-   Configurar HTTPS
-   Utilizar certificado válido (Let's Encrypt ou corporativo)
-   Configurar firewall
-   Ajustar backup automático

------------------------------------------------------------------------

## 📌 Observações

-   A instalação pode demorar vários minutos.
-   O processo gitlab-ctl reconfigure é pesado.
-   Recomendado não interromper a execução.