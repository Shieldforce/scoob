#!/bin/bash

if [ -v $5 ] && [ -v $6 ] && [[ "$5" = "--port" ]]; then
  port=83
else
  port=$6
fi

if [ -v $7 ] && [ -v $8 ] && [[ "$7" = "--redis-port" ]]; then
    redis_port=6386
else
    redis_port=${$8}
fi

if [ -v $9 ] && [ -v $10 ] && [[ "$9" = "--mysql-port" ]]; then
    mysql_port=3386
else
    mysql_port=${10}
fi

container="laravel-php-fpm-${4}-${port}"

# -----------------------------------------------------------

dir=scoob_implements/laravel/${4}

if [ -d $dir ]; then
  echo "Diretório scoob_implements ok!"
else
  if [ -d docker_scoob ]; then
    echo "Diretório scoob_implements ok!"
  else
    mkdir scoob_implements
  fi

  if [ -d scoob_implements/laravel ]; then
    echo "Diretório laravel ok!"
  else
    cd scoob_implements && mkdir laravel
    cd ..
  fi

  if [ -d scoob_implements/laravel/${4} ]; then
    echo "Diretório ${4} ok!"
  else
    cd scoob_implements/laravel && mkdir ${4}
    cd ..
    cd ..
  fi
fi

cp -R ${path_dir}/progs/runs/laravel/${4}/nginx $dir
cp -R ${path_dir}/progs/runs/laravel/${4}/php $dir
cp -R ${path_dir}/progs/runs/laravel/${4}/mariadb $dir
cp -R ${path_dir}/progs/runs/laravel/${4}/redis $dir
cp -R ${path_dir}/progs/runs/laravel/${4}/supervisord $dir
cp ${path_dir}/progs/runs/laravel/${4}/Dockerfile $dir
cp ${path_dir}/progs/runs/laravel/${4}/commands.sh $dir

chmod 777 $dir

sed -i "s/|mysql_port|/${mysql_port}/" $dir/mariadb/50-server.cnf
sed -i "s/|redis_port|/${redis_port}/" $dir/redis/redis.conf
# -----------------------------------------------------------

echo "";
bash ${path_dir}/progs/question.sh "
 É opcional, mas se preferir configurar os arquivos dos serviços,
 eles estão na pasta que acabou de ser criada na raiz do seu projeto : ($(pwd)/${dir}),
 para subir o container baseado nas suas configurações tecle S só depois de
 configurar os arquivos dos serviços!"
read -p " tecle S para continuar: [S / N]: " continue

if [[ "$continue" = "s" ]] || [[ "$continue" = "s" ]]; then
  bash ${path_dir}/progs/docker-remove.sh --docker-remove ${container}
  docker build \
              -t ${container} \
              --build-arg EXPOSE_PORT=${port} \
              --build-arg MYSQL_PORT=${mysql_port} \
              --build-arg REDIS_PORT=${redis_port} \
              --build-arg PATH_DIR=${dir} \
              --build-arg PATH_COR=$(pwd) \
              --build-arg VERSION=${4} \
              -f "${dir}/Dockerfile" .
  docker run \
              -d \
              --name ${container} \
              --restart unless-stopped \
              -p "${port}:80" \
              -v $(pwd):/var/www \
              ${container}
  if docker ps | grep "$container" &> /dev/null; then
    echo "";
    echo -e "\e[33;32m Container criado com sucesso! \e[0m";
    echo "";
    echo -e "\e[33;36m $(docker ps | grep ${container}) \e[0m";
    echo "";
    bash ${path_dir}/progs/success.sh 'Rodando comandos da implementação!'
    bash ${dir}/commands.sh ${container} "$@"
  else
    bash ${path_dir}/progs/error.sh 'Erro ao criar container!'
  fi
else
  echo "Você decidiu não continuar...!";
  exit;
fi


