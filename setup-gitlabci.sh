#!/bin/bash

# --- CONFIGURAÇÕES ---
# Se não passar um endereço como argumento, ele assume o IP da máquina
IP_LOCAL=$(hostname -I | awk '{print $1}')
ENDERECO=${1:-$IP_LOCAL}

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# --- FUNÇÕES ---

instalacao() {
    echo -e "${BLUE}########################################################${NC}"
    echo -e "${BLUE}#           -- INSTALAÇÃO DO GITLAB-CE --              #${NC}"
    echo -e "${BLUE}########################################################${NC}"

    log_info "Atualizando repositórios e instalando dependências..."
    sudo apt-get update -y -qq
    # debconf-set-selections evita prompts interativos do Postfix
    echo "postfix postfix/main_mailer_type string 'Internet Site'" | sudo debconf-set-selections
    sudo apt-get install -y -qq curl openssh-server ca-certificates tzdata perl postfix

    log_info "Adicionando repositório oficial do GitLab..."
    curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash

    log_info "Instalando pacote gitlab-ce (Isso pode demorar)..."
    sudo apt-get install gitlab-ce -y
}

configuracao() {
    log_info "Configurando EXTERNAL_URL para: http://$ENDERECO"
    
    # Altera o arquivo de configuração principal
    sudo sed -i "s|external_url 'http://gitlab.example.com'|external_url 'http://$ENDERECO'|g" /etc/gitlab/gitlab.rb
    
    log_info "Iniciando reconfigure (O motor do GitLab está sendo montado)..."
    sudo gitlab-ctl reconfigure

    if [ $? -eq 0 ]; then
        echo -e "\n${GREEN}################################################"
        echo -e "#        INSTALAÇÃO CONCLUÍDA COM SUCESSO!     #"
        echo -e "################################################${NC}"
        echo -e "🌐 Acesse: http://$ENDERECO"
        echo -e "🔑 Senha inicial: sudo cat /etc/gitlab/initial_root_password"
        echo -e "------------------------------------------------\n"
    else
        echo -e "${RED}🚨 Erro na configuração do GitLab. Verifique os logs.${NC}"
        exit 1
    fi
}

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

# --- EXECUÇÃO ---

# Verifica se é root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Erro: Execute como sudo.${NC}"
   exit 1
fi

instalacao
configuracao