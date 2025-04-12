#!/bin/bash

if [ -v $2 ]; then
  bash ${path_dir}/progs/error.sh  "Você precisa passar a flag --start";
  exit;
fi

docker run --rm \
    -u "$(id -u):$(id -g)" \
    -v "$(pwd):/var/www/html" \
    -w /var/www/html composer/composer \
     composer require shieldforce/scoob

echo ''
bash ${path_dir}/progs/success.sh 'Scoob inserido nos pacotes composer!'
