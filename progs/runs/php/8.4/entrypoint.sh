#!/bin/bash

# Inicia o supervisord com root
echo "[entrypoint] Iniciando supervisord..."
supervisord -c /etc/supervisor/supervisord.conf

# Muda para o usuário www-data (usuário padrão do PHP-FPM)
echo "[entrypoint] Mudando para usuário www-data e executando php-fpm"
exec gosu www-data php-fpm