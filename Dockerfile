FROM php:7.2-alpine3.12

ENV PHPIZE_DEPS \
    autoconf \
    cmake \
    file \
    g++ \
    gcc \
    libc-dev \
    pcre-dev \
    make \
    git \
    pkgconf \
    re2c \
    # for GD
    freetype-dev \
    libpng-dev  \
    libjpeg-turbo-dev \
    # for xslt
    libxslt-dev \
    # for intl extension
    icu-dev \
    openssl-dev \
    gettext-dev \
    rabbitmq-c-dev

RUN apk add --no-cache --virtual .persistent-deps \
    # for intl extension
    icu-libs \
    # for mongodb
    libssl1.1 \
    # for postgres
    postgresql-dev \
    # for soap
    libxml2-dev \
    # for amqp
    libressl-dev \
    # for GD
    freetype \
    libpng \
    libjpeg-turbo \
    libxslt \
    # for mbstring
    oniguruma-dev \
    libgcrypt \
    rabbitmq-c && \
    apk add --no-cache --virtual .build-deps \
      $PHPIZE_DEPS && \
    pecl install amqp \
        apcu \
        xdebug \
        mongodb \
        redis && \
    docker-php-ext-enable amqp apcu mongodb redis && \
    docker-php-ext-install -j$(nproc) \
        bcmath \
        opcache \
        intl \
        pdo_mysql \
        sockets \
        gd \
        pcntl \
        mysqli \
        soap \
        xsl \
        gettext && \
    apk add --no-cache \
    php7-curl \
    php7-pdo_mysql \
    php7-mysqli \
    php7-intl \
    php7-gettext \
    php7-pecl-imagick \
    php7-soap \
    php7-zip \
    php7-pecl-oauth \
    php7-pecl-apcu \
    php7-xml \
    php7-pecl-xdebug \
    php7-imap \
    php7-redis && \
    apk del .build-deps && \
    rm -rf /var/cache/apk/*

COPY php.custom.ini /usr/local/etc/php/conf.d
