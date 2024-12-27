#!/bin/bash

types=("docker-php-nginx" "docker-laravel")
versions=("7.4","8.1","8.2","8.3")

if [ -v $2 ]; then
  echo "Você precisa escolher um tipo de implementação, os tipos "
  echo "aceitáveis são: $(printf '%s, ' "${types[@]}") "
  exit
else
  if [[ "$2" = "docker-php-nginx" ]]; then
    if [ -v $3 ]; then
      echo "Você precisa passar a flag --version como terceiro parâmetro!!"
      exit
    else
      if [[ "$4" = "7.3" ]] || [[ "$4" = "7.4" ]] || [[ "$4" = "8.1" ]] || [[ "$4" = "8.2" ]] || [[ "$4" = "8.3" ]]; then
        bash ${path_dir}/progs/runs/php/$4/run.sh "$@"
      else
        echo "Você precisa escolher uma versão, as versões "
        echo "disponíveis são: $(printf '%s, ' "${versions[@]}") "
        exit
      fi
    fi
  elif [[ "$2" = "docker-laravel" ]]; then
    if [ -v $3 ]; then
      echo "Você precisa passar a flag --version como terceiro parâmetro!!"
      exit
    else
      if [[ "$4" = "7.3" ]] || [[ "$4" = "7.4" ]] || [[ "$4" = "8.1" ]] || [[ "$4" = "8.2" ]] || [[ "$4" = "8.3" ]]; then
        bash ${path_dir}/progs/runs/laravel/$4/run.sh "$@"
      else
        echo "Você precisa escolher uma versão, as versões "
        echo "disponíveis são: $(printf '%s, ' "${versions[@]}") "
        exit
      fi
    fi
  elif [[ "$2" = "docker-remove" ]]; then
    bash ${path_dir}/progs/docker-remove.sh "$3"
  else
    echo "Tipo de implementação não aceitável!"
    exit
  fi
fi
