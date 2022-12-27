#!/bin/bash

container=$1
composer=$9
migrate=$9

docker exec -it $container useradd -m $(whoami) &> /dev/null

if docker exec -it $container cat composer.json &> /dev/null; then
  if docker exec -it $container ls vendor &> /dev/null; then
    echo ""
  else
    if [[ $composer = "--composer-update" ]]; then
       docker exec -it $container su -c "composer update" -s /bin/sh $(whoami)
    fi
  fi
fi

if docker exec -it $container cat artisan &> /dev/null; then
  docker exec -it $container chmod -R 777 public/ &> /dev/null
  docker exec -it $container chmod -R 777 storage/ &> /dev/null
  docker exec -it $container chmod -R 777 bootstrap/ &> /dev/null
  if docker exec -it $container cat .env &> /dev/null; then
    if [[ $migrate = "--migrate-seed" ]]; then
      docker exec -it $container su -c "php artisan migrate --seed" -s /bin/sh $(whoami)
    fi
    if [[ $migrate = "--migrate" ]]; then
      docker exec -it $container su -c "php artisan migrate" -s /bin/sh $(whoami)
    fi
  else
    if docker exec -it $container cat .env.example &> /dev/null; then
        docker exec -it $container su -c "cp .env.example .env" -s /bin/sh $(whoami)
        docker exec -it $container su -c "php artisan migrate --seed" -s /bin/sh $(whoami)
    fi
  fi
fi