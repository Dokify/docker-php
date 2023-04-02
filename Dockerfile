# builded with run docker run -it --security-opt seccomp:unconfined --rm php:8.2.4-fpm-alpine and docker commit
FROM dokify/php:8.2.4-fpm-alpine-ext-amqp AS ext-amqp
#FROM php:8.2.4-fpm-alpine AS ext-amqp
#RUN apk add --no-cache rabbitmq-c-dev && \
#    mkdir -p /usr/src/php/ext/amqp && \
#    curl -fsSL https://pecl.php.net/get/amqp | tar xvz -C "/usr/src/php/ext/amqp" --strip 1 && \
#    docker-php-ext-install amqp

FROM dokify/php:8.2.4-fpm-alpine-ext-swoole AS ext-swoole
#FROM php:8.2.4-fpm-alpine AS ext-swoole
#RUN apk --update upgrade \
#    && apk add --no-cache autoconf automake make gcc g++ gnu-libiconv linux-headers openssl-dev  \
#    && apk add --no-cache --repository="http://dl-cdn.alpinelinux.org/alpine/edge/community" php82-sockets php82-dev \
#    && pecl install openswoole-22.0.0 --with-php-config=/usr/bin/php-config82 --with-libdir=/usr/include/php82/ext/sockets/ \
#    && rm -rf /tmp/pear

FROM dokify/php:8.2.4-fpm-alpine-ext-grpc AS ext-grpc
#FROM php:8.2.4-fpm-alpine AS ext-grpc
#RUN apk --update upgrade \
#    && apk add --no-cache autoconf automake make gcc g++ linux-headers zlib-dev \
#    && pecl install grpc \
#    && rm -rf /tmp/pear

FROM dokify/php:8.2.4-fpm-alpine-ext-build AS ext-build
#FROM php:8.2.4-fpm-alpine AS ext-build

#RUN apk --update upgrade \
#    && apk add --no-cache autoconf automake make gcc g++ icu-dev rabbitmq-c gnu-libiconv linux-headers  \
#    && pecl install \
#        apcu \
#        xdebug \
#        igbinary \
#        redis \
#        protobuf-3.22.1 \
#    && docker-php-ext-install -j$(nproc) \
#        bcmath \
#        opcache \
#        intl \
#        pdo_mysql \
#        sockets \
#	    pcntl \
#    && docker-php-ext-enable \
#        apcu \
#        opcache \
#    && rm -rf /tmp/pear


COPY php.custom.ini /usr/local/etc/php/conf.d
COPY --from=ext-amqp /usr/local/etc/php/conf.d/docker-php-ext-amqp.ini /usr/local/etc/php/conf.d/docker-php-ext-amqp.ini
COPY --from=ext-amqp /usr/local/lib/php/extensions/no-debug-non-zts-20220829/amqp.so /usr/local/lib/php/extensions/no-debug-non-zts-20220829/amqp.so
COPY --from=ext-swoole /usr/local/lib/php/extensions/no-debug-non-zts-20220829/openswoole.so /usr/local/lib/php/extensions/no-debug-non-zts-20220829/openswoole.so

FROM php:8.2.4-fpm-alpine

COPY --from=ext-build /usr/local/etc/php/conf.d /usr/local/etc/php/conf.d
COPY --from=ext-build /usr/local/lib/php/extensions /usr/local/lib/php/extensions

RUN apk add --no-cache rabbitmq-c icu-dev
