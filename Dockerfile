FROM php:8.0.6-fpm-alpine AS ext-amqp

RUN apk add --no-cache rabbitmq-c-dev && \
    mkdir -p /usr/src/php/ext/amqp && \
    curl -fsSL https://pecl.php.net/get/amqp | tar xvz -C "/usr/src/php/ext/amqp" --strip 1 && \
    docker-php-ext-install amqp

FROM php:8.0.6-fpm-alpine AS ext-build

RUN apk --update upgrade \
    && apk add --no-cache autoconf automake make gcc g++ icu-dev rabbitmq-c gnu-libiconv linux-headers  \
    && pecl install \
        apcu \
        xdebug \
        redis \
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
    && rm -rf /tmp/pear

COPY php.custom.ini /usr/local/etc/php/conf.d
COPY --from=ext-amqp /usr/local/etc/php/conf.d/docker-php-ext-amqp.ini /usr/local/etc/php/conf.d/docker-php-ext-amqp.ini
COPY --from=ext-amqp /usr/local/lib/php/extensions/no-debug-non-zts-20200930/amqp.so /usr/local/lib/php/extensions/no-debug-non-zts-20200930/amqp.so

FROM php:8.0.6-fpm-alpine

COPY --from=ext-build /usr/lib/preloadable_libiconv.so /usr/lib/preloadable_libiconv.so

# https://github.com/docker-library/php/issues/1121
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

COPY --from=ext-build /usr/local/etc/php/conf.d /usr/local/etc/php/conf.d
COPY --from=ext-build /usr/local/lib/php/extensions /usr/local/lib/php/extensions

RUN apk add --no-cache rabbitmq-c icu-dev
