#!/bin/bash

if [ -v $5 ] && [ -v $6 ] && [[ "$5" = "--port" ]]; then
  port=8084
else
  port=$6
fi

container="php-fpm-${4}-${port}"

# Cores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# -----------------------------------------------------------

dir=scoob_implements/php/${4}

if [ -d $dir ]; then
  bash ${path_dir}/progs/exec_spinner.sh \
      "" \
      "Verificando diretório scoob_implements..."
else
  if [ -d docker_scoob ]; then
    bash ${path_dir}/progs/exec_spinner.sh \
        "" \
        "Verificando diretório scoob_implements..."
  else
    bash ${path_dir}/progs/exec_spinner.sh \
        "mkdir scoob_implements > /dev/null 2>&1" \
        "Criando diretório scoob_implements..."
  fi

  if [ -d scoob_implements/php ]; then
    bash ${path_dir}/progs/exec_spinner.sh \
        "" \
        "Verificando diretório scoob_implements..."
  else
    cd scoob_implements && mkdir php
    cd ..
  fi

  if [ -d scoob_implements/php/${4} ]; then
    echo "Diretório ${4} ok!"
  else
    cd scoob_implements/php && mkdir ${4}
    cd ..
    cd ..
  fi
fi

cp -R ${path_dir}/progs/runs/php/${4}/nginx $dir
cp -R ${path_dir}/progs/runs/php/${4}/php $dir
cp -R ${path_dir}/progs/runs/php/${4}/supervisord $dir
cp ${path_dir}/progs/runs/php/${4}/Dockerfile $dir
cp ${path_dir}/progs/runs/php/${4}/commands.sh $dir

chmod 777 $dir

# -----------------------------------------------------------

echo "";
continue="S"

# Verifica se a rede scoob-network já existe
if ! docker network ls | grep -q "scoob-network" > /dev/null 2>&1; then
  bash ${path_dir}/progs/exec_spinner.sh \
      "docker network create scoob-network > /dev/null 2>&1" \
      "Criando rede scoob-network..."
else
  bash ${path_dir}/progs/exec_spinner.sh \
        "" \
        "Validando rede scoob-network..."
fi

# verifica de o container existe e remove
if {docker ps -a --format '{{.Names}}' | grep -wq "${container}";} > /dev/null 2>&1; then
  docker rm -f ${container}
fi

# bash ${path_dir}/progs/docker-remove.sh --docker-remove ${container}

bash ${path_dir}/progs/exec_spinner.sh \
        "docker build \
           -t ${container} \
           --build-arg EXPOSE_PORT=${port} \
           --build-arg PATH_DIR=${dir} \
           --build-arg PATH_COR=$(pwd) \
           --build-arg VERSION=${4} \
           -f "${dir}/Dockerfile" ." \
        "Construindo container ${container}..."

bash ${path_dir}/progs/exec_spinner.sh \
        "docker run \
           -d \
           --name ${container} \
           --restart unless-stopped \
           --network scoob-network \
           -p "${port}:80" \
           -v $(pwd):/var/www \
           ${container}" \
        "Rodando container ${container}..."

if docker ps | grep "$container" &> /dev/null; then
    bash ${path_dir}/progs/exec_spinner.sh \
            "bash ${dir}/commands-auto.sh ${container} $@ > /dev/null 2>&1" \
            "Rodando últimos comandos..."
else
    echo -e "${RED}❌ Erro ao criar container!!${NC}"
fi


