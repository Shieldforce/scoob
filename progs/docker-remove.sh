#!/bin/bash

if [ -v $3 ]; then
  bash ${path_dir}/progs/error.sh  "Você precisa passar um nome de container!";
  exit;
fi

if docker ps -a | grep "$3" &> /dev/null; then
  docker stop "$3" && docker rm "$3";
  docker image rm "$3" --force;
  echo ''
  bash ${path_dir}/progs/success.sh 'Container excluído com sucesso!'
fi

