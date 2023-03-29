FROM dokify/php:8.2.4-fpm-alpine-ext-amqp AS ext-amqp
FROM dokify/php:8.2.4-fpm-alpine-ext-build AS ext-build

COPY php.custom.ini /usr/local/etc/php/conf.d
COPY --from=ext-amqp /usr/local/etc/php/conf.d/docker-php-ext-amqp.ini /usr/local/etc/php/conf.d/docker-php-ext-amqp.ini
COPY --from=ext-amqp /usr/local/lib/php/extensions/no-debug-non-zts-20220829/amqp.so /usr/local/lib/php/extensions/no-debug-non-zts-20200930/amqp.so

FROM php:8.2.4-fpm-alpine

COPY --from=ext-build /usr/local/etc/php/conf.d /usr/local/etc/php/conf.d
COPY --from=ext-build /usr/local/lib/php/extensions /usr/local/lib/php/extensions

RUN apk add --no-cache rabbitmq-c icu-dev
