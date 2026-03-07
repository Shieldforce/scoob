# ==============================================
# Dockerfile completo: PHP 8.3-FPM + Nginx + SQL Server + Composer + Node/Yarn
# Base: Debian 13 (Trixie)
# ==============================================

FROM php:8.3-fpm

### ------------------------ ARGs ------------------------
ARG EXPOSE_PORT=8080
ARG PATH_DIR=./docker
ARG APP_DIR=/var/www
ARG HOST_UID=1000
ARG HOST_GID=1000
### ----------------------------------------------------

# Diretório de trabalho
WORKDIR $APP_DIR

# Criar grupo e usuário com base no host
RUN groupadd -g $HOST_GID www && \
    useradd -u $HOST_UID -g www -m www

# ----------------- Dependências base -----------------
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    apt-utils \
    gnupg \
    curl \
    ca-certificates \
    lsb-release \
    unixodbc-dev \
    libodbc2 \
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
    libicu-dev \
    nginx && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# ----------------- Microsoft SQL Server ODBC -----------------
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg && \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/debian/12/prod bookworm main" \
        > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql17 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# ----------------- Extensões SQL Server -----------------
RUN pecl install pdo_sqlsrv sqlsrv && \
    echo "extension=pdo_sqlsrv.so" > /usr/local/etc/php/conf.d/20-pdo_sqlsrv.ini && \
    echo "extension=sqlsrv.so" > /usr/local/etc/php/conf.d/21-sqlsrv.ini

# ----------------- Extensões PHP comuns -----------------
RUN docker-php-ext-install zip iconv simplexml pcntl gd fileinfo \
    mysqli pdo pdo_mysql pdo_pgsql pgsql session xml intl bcmath

# ----------------- Redis -----------------
RUN pecl install redis && docker-php-ext-enable redis

# ----------------- Composer -----------------
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# ----------------- Node.js + Yarn -----------------
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && npm install -g yarn && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# ----------------- Diretórios Nginx -----------------
RUN mkdir -p /var/log/nginx /etc/nginx/sites-available /var/lib/nginx/body /run && \
    chown -R www:www /var/log/nginx /etc/nginx/sites-available /var/lib/nginx /run

# ----------------- Configurações custom -----------------
COPY ${PATH_DIR}/php/php.ini /usr/local/etc/php/php.ini
COPY ${PATH_DIR}/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ${PATH_DIR}/nginx/sites /etc/nginx/sites-available

# ----------------- Permissões da aplicação -----------------
RUN chown -R www:www $APP_DIR

# ----------------- Porta -----------------
EXPOSE ${EXPOSE_PORT}

# ----------------- Usuário -----------------
USER www

# ----------------- Start do container -----------------
CMD ["sh", "-c", "nginx && php-fpm"]
