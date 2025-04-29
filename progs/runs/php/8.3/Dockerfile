FROM php:8.3-fpm

### Args ------------------------
ARG EXPOSE_PORT
ARG PATH_DIR
ARG PATH_COR
ARG APP_DIR=/var/www
ARG HOST_UID=1000
ARG HOST_GID=1000
### Args ------------------------

# Define diretório de trabalho
WORKDIR $APP_DIR

# Criação do grupo e usuário com base no host
RUN groupadd -g $HOST_GID www && \
    useradd -u $HOST_UID -g www -m www

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
    nginx

# Repositório Microsoft + msodbcsql17
RUN curl -sSL https://packages.microsoft.com/keys/microsoft.asc -o /etc/apt/keyrings/microsoft.asc && \
    gpg --dearmor < /etc/apt/keyrings/microsoft.asc > /etc/apt/keyrings/microsoft.gpg && \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/debian/12/prod bookworm main" \
    > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql17 && \
    rm -rf /var/lib/apt/lists/*

# Extensões SQL Server
RUN pecl install pdo_sqlsrv sqlsrv && \
    echo "extension=pdo_sqlsrv.so" > /usr/local/etc/php/conf.d/20-pdo_sqlsrv.ini && \
    echo "extension=sqlsrv.so" > /usr/local/etc/php/conf.d/20-sqlsrv.ini

# Extensões PHP
RUN docker-php-ext-install zip iconv simplexml pcntl gd fileinfo \
    mysqli pdo pdo_mysql pdo_pgsql pgsql session xml intl bcmath

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Node.js + Yarn
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && npm install -g yarn

# Cria diretórios do nginx e aplica permissões
RUN mkdir -p /var/log/nginx /etc/nginx/sites-available /var/lib/nginx/body /run && \
    chown -R www:www /var/log/nginx /etc/nginx/sites-available /var/lib/nginx /run

# Copia configs
COPY ${PATH_DIR}/php/php.ini /usr/local/etc/php/php.ini
COPY ${PATH_DIR}/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ${PATH_DIR}/nginx/sites /etc/nginx/sites-available

# Limpa cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Exposição de porta
EXPOSE ${EXPOSE_PORT}

# Troca para usuário não root
USER www

# Start do nginx + php-fpm
CMD ["sh", "-c", "nginx && php-fpm"]
