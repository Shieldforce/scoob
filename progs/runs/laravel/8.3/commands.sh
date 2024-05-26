#!/bin/bash

container=$1
migrate=""
composer=""

if [[ "$*" == *--migrate-seed* ]]; then
  migrate="--migrate-seed";
fi

if [[ "$*" == *--migrate* ]]; then
  migrate="--migrate";
fi

if [[ "$*" == *--migrate-fresh* ]]; then
  migrate="--migrate-fresh";
fi

if [[ "$*" == *--migrate-fresh* ]]; then
  migrate="--migrate-fresh";
fi

if [[ "$*" == *--composer-update* ]]; then
  composer="--composer-update";
fi

docker exec -it $container useradd -m $(whoami) &> /dev/null

if docker exec -it $container cat composer.json &> /dev/null; then
  if docker exec -it $container ls vendor &> /dev/null; then
    echo ""
  else
    if [[ $composer = "--composer-update" ]]; then
       docker exec -it $container su -c "composer update" -s /bin/sh $(whoami)
       docker exec -it $container su -c "php artisan storage:link" -s /bin/sh $(whoami)
    fi
  fi
fi

if docker exec -it $container cat artisan &> /dev/null; then
  docker exec -it $container chmod -R 777 public/ &> /dev/null
  docker exec -it $container chmod -R 777 storage/ &> /dev/null
  docker exec -it $container chmod -R 777 bootstrap/ &> /dev/null
  if docker exec -it $container cat .env &> /dev/null; then
    if [[ $migrate = "--migrate-seed" ]]; then
      docker exec -it $container su -c "yes | php artisan migrate --seed --force --no-interaction" -s /bin/sh $(whoami)
    fi
    if [[ $migrate = "--migrate-fresh" ]]; then
      docker exec -it $container su -c "yes | php artisan migrate:fresh --seed --force --no-interaction" -s /bin/sh $(whoami)
    fi
    if [[ $migrate = "--migrate" ]]; then
      docker exec -it $container su -c "yes | php artisan migrate --force --no-interaction" -s /bin/sh $(whoami)
    fi
  else
    if docker exec -it $container cat .env.example &> /dev/null; then
      if docker exec -it $container cat .env &> /dev/null; then
        echo "";
      else
        docker exec -it $container su -c "cp .env.example .env" -s /bin/sh $(whoami)
      fi
    fi
  fi
fi