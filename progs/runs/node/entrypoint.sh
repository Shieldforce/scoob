#!/bin/bash
# Na primeira subida (sem node_modules) instala as dependências e roda o build, se o projeto tiver.
# Nas seguintes só sobe a aplicação: atualização de código é com o script de deploy do projeto.
set -e
cd /var/www

if [ -f package.json ] && [ ! -d node_modules ]; then
  echo "[scoob] node_modules não encontrado, instalando dependências..."
  if [ -f package-lock.json ]; then
    npm ci --include=dev --no-audit --no-fund
  else
    npm install --include=dev --no-audit --no-fund
  fi
  if node -e "process.exit(require('./package.json').scripts?.build ? 0 : 1)"; then
    npm run build
  fi
fi

exec "$@"
