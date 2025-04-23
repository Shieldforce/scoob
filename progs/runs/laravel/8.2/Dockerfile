FROM php:8.2-fpm

### Args ------------------------
ARG EXPOSE_PORT
ARG MYSQL_PORT
ARG REDIS_PORT
ARG PATH_DIR
ARG PATH_COR
ARG APP_DIR=/var/www
ENV MARIADB_MYSQL_SOCKET_DIRECTORY='/var/run/mysqld'
### Args ------------------------

# Layer Workdir --------------------------------------------------
WORKDIR $APP_DIR

# Layer add Permissions dir
RUN chmod 755 -R * && chown -R www-data: *

# Layers install dependencies ------------------------------------------------------------------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    apt-utils \
    supervisor \
    unixodbc-dev \
    libodbc1 \
    libtool \
    zlib1g-dev \
    libzip-dev \
    unzip \
    libpng-dev \
    libpq-dev \
    libxml2-dev \
    nginx \
    redis-server \
    mariadb-server \
    mariadb-client \
    nano

RUN apt-get update && apt-get upgrade -y

# Adiciona repositório da Microsoft com suporte a chave GPG moderna
RUN curl -sSL https://packages.microsoft.com/keys/microsoft.asc -o /etc/apt/keyrings/microsoft.asc && \
    gpg --dearmor < /etc/apt/keyrings/microsoft.asc > /etc/apt/keyrings/microsoft.gpg && \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/debian/12/prod bookworm main" \
    > /etc/apt/sources.list.d/mssql-release.list

# Instala msodbcsql17
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql17 && \
    rm -rf /var/lib/apt/lists/*

# Instala as extensões do SQL Server
RUN pecl install pdo_sqlsrv sqlsrv && \
    echo "extension=pdo_sqlsrv.so" > /usr/local/etc/php/conf.d/20-pdo_sqlsrv.ini && \
    echo "extension=sqlsrv.so" > /usr/local/etc/php/conf.d/20-sqlsrv.ini

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Node.js (LTS) e Yarn
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn

RUN docker-php-ext-install zip simplexml pcntl gd fileinfo \
    mysqli pdo pdo_mysql pdo_pgsql pgsql session xml intl bcmath

RUN pecl install redis \
    && docker-php-ext-enable redis

# Layers Copy folders and file to local
COPY ${PATH_DIR}/supervisord/supervisord.conf /etc/supervisor
COPY ${PATH_DIR}/supervisord/conf /etc/supervisord.d/
COPY ${PATH_DIR}/php/php.ini /usr/local/etc/php/php.ini
COPY ${PATH_DIR}/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ${PATH_DIR}/nginx/sites /etc/nginx/sites-available
COPY ${PATH_DIR}/redis/redis.conf /etc/redis/redis.conf
RUN mkdir -p $MARIADB_MYSQL_SOCKET_DIRECTORY && \
    chmod 777 $MARIADB_MYSQL_SOCKET_DIRECTORY
COPY ${PATH_DIR}/mariadb/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
RUN chmod 0644 /etc/mysql/mariadb.conf.d/50-server.cnf

# Layer Clear
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE ${EXPOSE_PORT} ${MYSQL_PORT} ${REDIS_PORT}

# finish dockerfile
ADD ${PATH_DIR}/supervisord/supervisord.conf /etc/supervisor/supervisord.conf
ADD ${PATH_DIR}/supervisord/conf /etc/supervisord.d/
CMD ["supervisord", "-n"]
