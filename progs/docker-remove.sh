#!/bin/bash

if [ -v $2 ]; then
  bash ${path_dir}/progs/error.sh  "Você precisa passar um nome de container!";
  exit;
fi

if docker ps | grep "$2" &> /dev/null; then
  docker stop "$2" && docker rm "$2";
  bash ${path_dir}/progs/success.sh 'Container excluído com sucesso!'
else
  bash ${path_dir}/progs/error.sh  "Container não encontrado!!";
  exit;
fi

if docker ps | grep "$2" &> /dev/null; then
  docker image rm "$2" --force;
  bash ${path_dir}/progs/success.sh 'Imagem excluído com sucesso!'
fi

