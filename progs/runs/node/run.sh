#!/bin/bash
# scoob --type docker-node --version {20|22|24} --port {porta}
# Sobe a pasta atual como aplicação Node: a app escuta a variável PORT (3000) dentro do container
# e o host publica em 127.0.0.1:{porta} (o nginx do host faz o proxy, igual aos containers PHP).

if [ -v $5 ] && [ -v $6 ] && [[ "$5" = "--port" ]]; then
  port=3022
else
  port=$6
fi

container="node-${4}-${port}"
dir=scoob_implements/node/${4}

mkdir -p ${dir}
echo "$container" > scoob_implements/container.txt

cp ${path_dir}/progs/runs/node/Dockerfile $dir
cp ${path_dir}/progs/runs/node/entrypoint.sh $dir
cp ${path_dir}/progs/runs/node/commands.sh $dir
chmod -R 755 $dir

# -----------------------------------------------------------

echo "";
bash ${path_dir}/progs/question.sh "
 É opcional, mas se preferir configurar os arquivos do container,
 eles estão na pasta que acabou de ser criada na raiz do seu projeto : ($(pwd)/${dir}),
 o .env do projeto é lido pela própria aplicação (a pasta é montada em /var/www).
 Para subir o container tecle S só depois de configurar!"
read -p " tecle S para continuar: [S / N]: " continue

if ! docker network ls | grep -q "scoob-network"; then
  echo "Criando rede scoob-network..."
  docker network create scoob-network
else
  echo "Rede scoob-network já existe."
fi

if [[ "$continue" == [sS] ]]; then
  # só remove o container existente depois da confirmação
  if docker ps -a --format '{{.Names}}' | grep -wq "${container}"; then
    echo "Removendo container existente..."
    docker rm -f ${container}
  fi
  docker image rm -f ${container} &> /dev/null || true
  docker build \
      -t ${container} \
      --build-arg VERSION=${4} \
      --build-arg HOST_UID=$(id -u) \
      --build-arg HOST_GID=$(id -g) \
      -f "${dir}/Dockerfile" ${dir}
  docker run \
      -d \
      --name ${container} \
      --restart unless-stopped \
      --network scoob-network \
      -p "127.0.0.1:${port}:3000" \
      -v $(pwd):/var/www \
      --user $(id -u):$(id -g) \
      ${container}
  if docker ps | grep "$container" &> /dev/null; then
    echo "";
    echo -e "\e[33;32m Container criado com sucesso! \e[0m";
    echo "";
    echo -e "\e[33;36m $(docker ps | grep ${container}) \e[0m";
    echo "";
    bash ${path_dir}/progs/success.sh 'Rodando comandos da implementação!'
    bash ${dir}/commands.sh ${container} "$@"
  else
    bash ${path_dir}/progs/error.sh 'Erro ao criar container!'
  fi
else
  echo "Você decidiu não continuar...!";
  exit;
fi
