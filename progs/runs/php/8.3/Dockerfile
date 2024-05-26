ARG VERSION

FROM php:${VERSION}-fpm

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

# Layers install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    apt-utils \
    supervisor \
    zlib1g-dev \
    libzip-dev \
    unzip \
    libpng-dev \
    libpq-dev \
    libxml2-dev \
    nginx

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN docker-php-ext-install zip iconv simplexml pcntl gd fileinfo \
    mysqli pdo pdo_mysql pdo_pgsql pgsql session xml

# Layers Copy folders and file to local
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
CMD /usr/bin/supervisord -n