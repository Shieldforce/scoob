#!/bin/bash

container="php-fpm-7.4-${PPID}"

if [ -v $5 ] && [ -v $6 ] && [[ "$5" = "--port" ]]; then
  port=8081
else
  port=$6
fi

docker build \
            -t ${container} \
            --build-arg EXPOSE_PORT=${port} \
            --build-arg PATH_DIR=${path_dir} \
            -f "${path_dir}/progs/runs/php/${4}/Dockerfile" .

docker run \
            -d \
            --name ${container} \
            -p "${port}:80" \
            ${container}


echo "";
echo -e "\e[33;32m Container criado com sucesso! \e[0m";
echo "";
echo -e "\e[33;36m $(docker ps | grep ${container}) \e[0m";
