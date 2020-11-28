FROM php:7.4-fpm-buster

RUN apt update -yq \
    && apt install -yq --no-install-recommends autoconf automake make gcc g++ libicu-dev librabbitmq-dev \
    apt-transport-https \
    ca-certificates \
    gnupg2 \
    nginx \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
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

EXPOSE 80

STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]