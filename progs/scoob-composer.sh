#!/bin/bash

echo "teste";

if [ -v $2 ]; then
  bash ${path_dir}/progs/error.sh  "Você precisa passar a flag --composer";
  exit;
fi

if [ -v $3 ]; then
  bash ${path_dir}/progs/error.sh  "Você precisa passar um comando composer!";
  exit;
fi

if [ -v $4 ]; then
  bash ${path_dir}/progs/error.sh  "Você precisa passar o nome do container!";
  exit;
fi

docker run --rm \
    -u "$(id -u):$(id -g)" \
    -v "$(pwd):/var/www/html" \
    -w /var/www/html composer/composer \
     $($3)

echo ''
bash ${path_dir}/progs/success.sh 'Comando composer executado com sucesso!'

