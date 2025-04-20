#!/bin/bash

# exec_com_spinner.sh
# Uso: ./exec_com_spinner.sh "comando" "mensagem"

# Cores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

COMANDO="$1"
MENSAGEM="$2"

# Função spinner
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    while kill -0 $pid 2>/dev/null; do
        for i in $(seq 0 ${#spinstr}); do
            printf "\r${YELLOW}${MENSAGEM} %s${NC}" "${spinstr:i:1}"
            sleep $delay
        done
    done
    printf "\r"
}

# Executa o comando em background
bash -c "$COMANDO" > /dev/null 2>&1 &
PID=$!
spinner $PID
wait $PID
RESULT=$?

# Mensagem final
if [ $RESULT -eq 0 ]; then
    echo -e "${GREEN}✅ ${MENSAGEM} Finalizado com sucesso!${NC}"
else
    echo -e "${RED}❌ ${MENSAGEM} Erro ao realizar o procedimento!${NC}"
    exit 1
fi
