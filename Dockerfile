FROM php:8.4.8RC1-fpm-alpine3.20 AS base

WORKDIR /app

RUN apk add --no-cache \
    bash \
    git \
    unzip \
    curl \
    libzip-dev \
    icu-dev \
    oniguruma-dev \
    nodejs \
    npm

RUN docker-php-ext-install pdo pdo_mysql pcntl \
    && docker-php-ext-enable pdo_mysql

RUN curl -sS https://getcomposer.org/download/2.8.3/composer.phar -o /usr/local/bin/composer \
    && chmod +x /usr/local/bin/composer

COPY . .

RUN composer install --no-interaction --prefer-dist --optimize-autoloader

RUN npm install && npm run build

# FROM base AS reverb
# CMD ["php", "artisan", "reverb:start"]

# FROM base AS workers
# CMD ["php", "artisan", "queue:work"]
