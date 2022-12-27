#!/bin/bash

types=("docker-php")
versions=("7.4")

if [ -v $2 ]; then
  echo "Você precisa escolher um tipo de implementação, os tipos "
  echo "aceitáveis são: $(printf '%s, ' "${types[@]}") "
  exit
else
  if [[ "$2" = "docker-php" ]]; then
    if [ -v $3 ]; then
      echo "Você precisa passar a flag --version como terceiro parâmetro!!"
      exit
    else
      if [[ "$4" = "7.4" ]] || [[ "$4" = "8.1" ]] || [[ "$4" = "8.2" ]]; then
        bash ${path_dir}/progs/runs/php/$4/run.sh "$@"
      else
        echo "Você precisa escolher uma versão, as versões "
        echo "disponíveis são: $(printf '%s, ' "${versions[@]}") "
        exit
      fi
    fi
  else
    echo "Tipo de implementação não aceitável!"
    exit
  fi
fi
