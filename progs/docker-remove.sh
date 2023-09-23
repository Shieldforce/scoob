#!/bin/bash

if [ -v $2 ]; then
  bash ${path_dir}/progs/error.sh  "Você precisa passar um nome de container!";
  exit;
fi

if docker ps -a | grep "$2" &> /dev/null; then
  docker stop "$2" && docker rm "$2";
  docker image rm "$2" --force;
  echo ''
  bash ${path_dir}/progs/success.sh 'Container excluído com sucesso!'
fi

