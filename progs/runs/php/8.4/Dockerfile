FROM php:8.4-fpm

ARG EXPOSE_PORT
ARG PATH_DIR
ARG PATH_COR
ARG APP_DIR=/var/www

WORKDIR $APP_DIR

RUN usermod -u 9977 www-data && groupmod -g 9977 www-data
USER www-data

# Instala dependências do sistema
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils gnupg2 curl ca-certificates lsb-release apt-transport-https \
    unixodbc-dev libodbc1 libtool gcc g++ make autoconf libc-dev pkg-config \
    zlib1g-dev libzip-dev unzip libpng-dev libpq-dev libxml2-dev libssl-dev \
    supervisor nginx gosu

# Repositório Microsoft SQL Server
RUN curl -sSL https://packages.microsoft.com/keys/microsoft.asc -o /etc/apt/keyrings/microsoft.asc && \
    gpg --dearmor < /etc/apt/keyrings/microsoft.asc > /etc/apt/keyrings/microsoft.gpg && \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/debian/12/prod bookworm main" \
    > /etc/apt/sources.list.d/mssql-release.list

RUN apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql17 && \
    rm -rf /var/lib/apt/lists/*

# Extensões PHP e SQL Server
RUN pecl install pdo_sqlsrv sqlsrv && \
    echo "extension=pdo_sqlsrv.so" > /usr/local/etc/php/conf.d/20-pdo_sqlsrv.ini && \
    echo "extension=sqlsrv.so" > /usr/local/etc/php/conf.d/20-sqlsrv.ini

RUN docker-php-ext-install zip iconv simplexml pcntl gd fileinfo \
    mysqli pdo pdo_mysql pdo_pgsql pgsql session xml intl bcmath

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Node e Yarn
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && npm install -g yarn

# Configurações
COPY ${PATH_DIR}/supervisord/supervisord.conf /etc/supervisor/
COPY ${PATH_DIR}/supervisord/conf /etc/supervisord.d/
COPY ${PATH_DIR}/php/php.ini /usr/local/etc/php/php.ini
COPY ${PATH_DIR}/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ${PATH_DIR}/nginx/sites /etc/nginx/sites-available

# Entrypoint seguro
COPY ${PATH_DIR}/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE ${EXPOSE_PORT}

ENTRYPOINT ["/entrypoint.sh"]
