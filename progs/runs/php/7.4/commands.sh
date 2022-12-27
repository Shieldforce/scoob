#!/bin/bash

docker exec -it $1 useradd -m $(whoami) &> /dev/null

if docker exec -it $1 cat composer.json &> /dev/null; then
  if docker exec -it $1 ls vendor &> /dev/null; then
    echo ""
  else
    docker exec -it $1 su -c "composer update" -s /bin/sh $(whoami)
  fi
fi

if docker exec -it $1 cat artisan &> /dev/null; then
  docker exec -it $1 chmod -R 777 public/ &> /dev/null
  docker exec -it $1 chmod -R 777 storage/ &> /dev/null
  docker exec -it $1 chmod -R 777 bootstrap/ &> /dev/null
  if docker exec -it $1 cat .env &> /dev/null; then
    docker exec -it $1 su -c "php artisan migrate --seed" -s /bin/sh $(whoami)
  else
    if docker exec -it $1 cat .env.example &> /dev/null; then
        docker exec -it $1 su -c "cp .env.example .env" -s /bin/sh $(whoami)
        docker exec -it $1 su -c "php artisan migrate --seed" -s /bin/sh $(whoami)
    fi
  fi
fi