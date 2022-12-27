#!/bin/bash

types=("docker-php" "docker-laravel" "docker-node" "docker-apache" "docker-nginx")

if [ -v $2 ]; then
  echo "Você precisa escolher um tipo de implementação, os tipos ";
  echo "aceitáveis são: `printf '%s, ' "${types[@]}"` ";
  exit 1;
else

  if [[ "$2" = "docker-php" ]]; then
    echo "php";
  elif [[ "$2" = "docker-laravel" ]]; then
    echo "Docker laravel ainda vai ser implementado!";
  elif [[ "$2" = "docker-nodejs" ]]; then
    echo "Docker nodejs ainda vai ser implementado!";
  elif [[ "$2" = "docker-apache" ]]; then
    echo "Docker apache ainda vai ser implementado!";
  elif [[ "$2" = "docker-nginx" ]]; then
    echo "Docker nginx ainda vai ser implementado!";
  else
    echo "Tipo de implementação não aceitável!";
    exit;
  fi

fi




