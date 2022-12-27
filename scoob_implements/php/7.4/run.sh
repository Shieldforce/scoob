#!/bin/bash

container="php-fpm-7.4-${PPID}"

if [ -v $5 ] && [ -v $6 ] && [[ "$5" = "--port" ]]; then
  port=8081
else
  port=$6
fi

if [ -v $7 ] && [ -v $8 ] && [[ "$7" = "--app-build" ]]; then
  app_build=.
else
  app_build=$8
fi

# -----------------------------------------------------------
dir=scoob_implements/php/${4}

if [ -d $dir ]; then
  echo "Diretório scoob_implements ok!"
else
  if [ -d docker_scoob ]; then
    echo "Diretório scoob_implements ok!"
  else
    mkdir scoob_implements
  fi

  if [ -d scoob_implements/php ]; then
    echo "Diretório php ok!"
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

cp -R ${path_dir}/progs/runs/php/${4}/* $dir
chmod 777 $dir

# -----------------------------------------------------------

echo "";
read -p "É opcional, mas se preferir configurar os arquivos dos serviços,
eles estão na pasta criada: (${dir}), para subir o container baseado nas
suas configurações tecle S só depois de configurar os arquivos dos serviços,
tecle S para continuar: [S / N]: " continue

if [[ "$continue" = "s" ]] || [[ "$continue" = "s" ]]; then

  docker build \
              -t ${container} \
              --build-arg EXPOSE_PORT=${port} \
              --build-arg PATH_DIR=${dir} \
              -f "${dir}/Dockerfile" $app_build

  docker run \
              -d \
              --name ${container} \
              -p "${port}:80" \
              ${container}

  if docker ps | grep "$container" &> /dev/null; then
    echo "";
    echo -e "\e[33;32m Container criado com sucesso! \e[0m";
    echo "";
    echo -e "\e[33;36m $(docker ps | grep ${container}) \e[0m";
  else
    bash error.sh
  fi

else
  echo "Você decidiu não continuar...!";
  exit;
fi


