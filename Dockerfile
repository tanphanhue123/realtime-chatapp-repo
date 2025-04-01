FROM php:8.3.9-fpm-alpine3.20 AS base

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

# Cài PHP extensions
RUN docker-php-ext-install pdo pdo_mysql pcntl \
    && docker-php-ext-enable pdo_mysql

# Cài Composer 2.8.3
RUN curl -sS https://getcomposer.org/download/2.8.3/composer.phar -o /usr/local/bin/composer \
    && chmod +x /usr/local/bin/composer

# Copy toàn bộ mã nguồn (bao gồm artisan)
COPY . .

# Cài đặt PHP dependencies
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

ARG VITE_REVERB_APP_KEY=my-app-key # Có thể thêm giá trị mặc định nếu muốn
ARG VITE_REVERB_HOST=http://realtime-chatapp.com
ARG VITE_REVERB_PORT=80 # Port mặc định của Reverb thường là 8080
ARG VITE_REVERB_SCHEME=http
ARG VITE_REVERB_PATH=/reverb

# Gán ARG vào ENV để npm/vite có thể đọc được trong quá trình RUN
ENV VITE_REVERB_APP_KEY=${VITE_REVERB_APP_KEY}
ENV VITE_REVERB_HOST=${VITE_REVERB_HOST}
ENV VITE_REVERB_PORT=${VITE_REVERB_PORT}
ENV VITE_REVERB_SCHEME=${VITE_REVERB_SCHEME}
ENV VITE_REVERB_PATH=${VITE_REVERB_PATH}

# Cài đặt JS dependencies và build frontend
RUN npm install && npm run build

# FROM base AS reverb
# CMD ["php", "artisan", "reverb:start"]

# FROM base AS workers
# CMD ["php", "artisan", "queue:work"]
