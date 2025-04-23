#!/bin/bash

# Caminho base
path_dir=$(dirname "$0")

# Verifica se a flag --redis-ext foi passada e já armazena o valor
redis_ext=""

for arg in "$@"; do
  case $arg in
    --redis-ext=*)
      redis_ext="${arg#*=}"
      ;;
  esac
done

# Validação obrigatória da flag --redis-ext (logo no início)
if [[ -z "$redis_ext" ]]; then
  bash "${path_dir}/error.sh" "Você precisa passar a flag obrigatória --redis-ext=alguma_coisa"
  exit 1
fi

# Valores padrão
redis_port=6379
redis_pass="@ScoobRedis-dg333445fvcv"
redis_container="scoob-redis"
redis_network="scoob-network"
init_conf="${path_dir}/redis.conf"

# Parsing dos demais parâmetros
for arg in "$@"; do
  case $arg in
    --port=*)
      redis_port="${arg#*=}"
      ;;
    --pass=*)
      redis_pass="${arg#*=}"
      ;;
    --container=*)
      redis_container="${arg#*=}"
      ;;
    --network=*)
      redis_network="${arg#*=}"
      ;;
    --init-conf=*)
      init_conf="${arg#*=}"
      ;;
  esac
done

# Verifica se a rede já existe
if ! docker network ls | grep -q "$redis_network"; then
  echo "Criando rede $redis_network..."
  docker network create "$redis_network"
else
  echo "Rede $redis_network já existe."
fi

# Remove container se já existe
if docker ps -a --format '{{.Names}}' | grep -wq "$redis_container"; then
  echo "Removendo container existente: $redis_container..."
  docker rm -f "$redis_container"
fi

# Gera o conteúdo do arquivo de conf inicial
cat > "$init_conf" <<EOF
# Redis config básico

# Porta padrão
port ${redis_port}

# Bind apenas no localhost (altere conforme necessário)
bind 0.0.0.0

# Proteção mínima (desabilitada para aceitar conexões externas)
protected-mode no

# Permitir persistência em disco
save 900 1
save 300 10
save 60 10000

# Caminho para o arquivo de dump
dir /data

# Nome do arquivo de dump
dbfilename dump.rdb

# Permitir que o Redis rode em background (não necessário em container)
daemonize no

# Log para o stdout (bom para Docker)
logfile ""

# Loglevel: notice | verbose | debug | warning
loglevel notice

# Senha para autenticação (opcional, mas recomendado em produção)
requirepass '${pass}'

# Permitir acesso via sockets Unix (opcional)
# unixsocket /tmp/redis.sock
# unixsocketperm 700
EOF

# Sobe o container Redis
docker run -d --rm \
   --name ${$redis_container} \
   -p ${redis_port}:6379 \
   --network "$redis_network" \
   --network-alias "${redis_container}-redis" \
   -v ${init_conf}:/usr/local/etc/redis/redis.conf \
   redis \
   redis-server /usr/local/etc/redis/redis.conf

echo ''
bash "${path_dir}/success.sh" "Redis '$redis_container' upado com sucesso na porta $redis_port!"