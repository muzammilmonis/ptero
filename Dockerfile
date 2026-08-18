FROM php:8.3-fpm-bookworm

ENV DEBIAN_FRONTEND=noninteractive \
    HOME=/home/container \
    USER=container

LABEL org.opencontainers.image.source="https://github.com/muzammilmonis/ahhhh" \
      org.opencontainers.image.description="Portable PHP 8.3 runtime for hosting Pterodactyl Panel inside a Pterodactyl server container."

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       bash ca-certificates curl git unzip zip tar \
       nginx redis-server supervisor \
       libpng-dev libjpeg62-turbo-dev libfreetype6-dev \
       libzip-dev libonig-dev libxml2-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j"$(nproc)" bcmath gd mbstring pdo_mysql zip \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --create-home --home-dir /home/container --shell /bin/bash container \
    && mkdir -p /home/container \
    && chown -R container:container /home/container

COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

USER container
WORKDIR /home/container

CMD ["bash"]
