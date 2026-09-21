FROM php:7.3-fpm

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

# ----------------- Mídia: vídeo e arquivos compactados -----------------
# A IA que analisa documento (Jarvis, no federal-zap) lê imagem e PDF, mas
# não abre vídeo nem pacote. O ffmpeg tira quadros do vídeo da vistoria, e
# unar/7z abrem o .rar que o associado manda quando junta tudo numa pasta
# (.zip o próprio PHP já abre, via ZipArchive).
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ffmpeg \
    p7zip-full \
    unar && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN docker-php-ext-install zip iconv simplexml pcntl gd fileinfo \
    mysqli pdo pdo_mysql pdo_pgsql pgsql session xml intl

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
CMD ["supervisord", "-n"]