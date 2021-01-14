FROM php:7.4-fpm-alpine

RUN apk --update upgrade \
    && apk add --no-cache autoconf automake make gcc g++ icu-dev rabbitmq-c rabbitmq-c-dev \
    && pecl install \
        amqp \
        xdebug \
    && docker-php-ext-install -j$(nproc) \
        bcmath \
        intl \
        pdo_mysql \
        sockets \
    && docker-php-ext-enable \
        xdebug \
        amqp

COPY php.custom.ini /usr/local/etc/php/conf.d

WORKDIR /app