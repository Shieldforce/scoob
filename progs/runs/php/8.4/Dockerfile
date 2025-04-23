FROM php:8.4-fpm

### Args ------------------------
ARG EXPOSE_PORT
ARG PATH_DIR
ARG PATH_COR
ARG APP_DIR=/var/www
### Args ------------------------

# Layer Workdir --------------------------------------------------
WORKDIR $APP_DIR

# Layer add Permissions dir
RUN chmod 755 -R * && chown -R www-data: *

# Instala dependências base do sistema
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
    gnupg2 \
    curl \
    ca-certificates \
    lsb-release \
    apt-transport-https \
    unixodbc-dev \
    libodbc1 \
    libtool \
    gcc \
    g++ \
    make \
    autoconf \
    libc-dev \
    pkg-config \
    zlib1g-dev \
    libzip-dev \
    unzip \
    libpng-dev \
    libpq-dev \
    libxml2-dev \
    libssl-dev \
    supervisor \
    nginx

# Adiciona o repositório da Microsoft
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/debian/$(lsb_release -rs)/prod.list > /etc/apt/sources.list.d/mssql-release.list

# Instala msodbcsql17
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql17 && \
    rm -rf /var/lib/apt/lists/*

# Instala as extensões do SQL Server
RUN apt-get update && pecl install pdo_sqlsrv sqlsrv && \
    echo "extension=pdo_sqlsrv.so" > /usr/local/etc/php/conf.d/20-pdo_sqlsrv.ini && \
    echo "extension=sqlsrv.so" > /usr/local/etc/php/conf.d/20-sqlsrv.ini

# Instala extensões PHP
RUN docker-php-ext-install zip iconv simplexml pcntl gd fileinfo \
    mysqli pdo pdo_mysql pdo_pgsql pgsql session xml intl bcmath

# Instala Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Node.js (LTS) e Yarn
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn

# Copia configs
COPY ${PATH_DIR}/supervisord/supervisord.conf /etc/supervisor
COPY ${PATH_DIR}/supervisord/conf /etc/supervisord.d/
COPY ${PATH_DIR}/php/php.ini /usr/local/etc/php/php.ini
COPY ${PATH_DIR}/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ${PATH_DIR}/nginx/sites /etc/nginx/sites-available

# Layer Clear
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE ${EXPOSE_PORT}

# finish dockerfile
ADD ${PATH_DIR}/supervisord/supervisord.conf /etc/supervisor/supervisord.conf
ADD ${PATH_DIR}/supervisord/conf /etc/supervisord.d/
CMD ["supervisord", "-n"]
