FROM php:7.4-fpm-alpine

RUN apk --update upgrade \
    && apk add --no-cache autoconf automake make gcc g++ icu-dev rabbitmq-c rabbitmq-c-dev \
    && pecl install \
        amqp \
        apcu \
        xdebug \
    && docker-php-ext-install -j$(nproc) \
        bcmath \
        opcache \
        intl \
        pdo_mysql \
        sockets \
    && docker-php-ext-enable \
        amqp \
        apcu \
        opcache

COPY php.custom.ini /usr/local/etc/php/conf.d
