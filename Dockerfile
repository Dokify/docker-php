FROM php:8.0.6-fpm-alpine AS ext-amqp

RUN apk add --no-cache rabbitmq-c-dev && \
    mkdir -p /usr/src/php/ext/amqp && \
    curl -fsSL https://pecl.php.net/get/amqp | tar xvz -C "/usr/src/php/ext/amqp" --strip 1 && \
    docker-php-ext-install amqp

FROM php:8.0.6-fpm-alpine

RUN apk --update upgrade \
    && apk add --no-cache autoconf automake make gcc g++ icu-dev rabbitmq-c \
    && pecl install \
        apcu \
        xdebug \
    && docker-php-ext-install -j$(nproc) \
        bcmath \
        opcache \
        intl \
        pdo_mysql \
        sockets \
	pcntl \
    && docker-php-ext-enable \
        apcu \
        opcache \
        xdebug

COPY php.custom.ini /usr/local/etc/php/conf.d
COPY --from=ext-amqp /usr/local/etc/php/conf.d/docker-php-ext-amqp.ini /usr/local/etc/php/conf.d/docker-php-ext-amqp.ini
COPY --from=ext-amqp /usr/local/lib/php/extensions/no-debug-non-zts-20200930/amqp.so /usr/local/lib/php/extensions/no-debug-non-zts-20200930/amqp.so
