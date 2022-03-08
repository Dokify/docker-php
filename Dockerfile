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
    rabbitmq-c-dev \
    gearman-dev \
    patch \
    libtool

RUN apk add --no-cache --virtual .persistent-deps  -X 'http://dl-cdn.alpinelinux.org/alpine/edge/testing' \
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
    gearman-libs \
    rabbitmq-c && \
    apk add --update --no-cache --virtual .build-deps -X 'http://dl-cdn.alpinelinux.org/alpine/edge/testing' \
      $PHPIZE_DEPS && \
    pecl install amqp \
        apcu \
        xdebug \
        mongodb \
        gearman \
        apcu_bc \
        redis && \
    docker-php-ext-enable amqp apcu mongodb redis gearman && \
    echo "extension=apc" >> /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini && \
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
    php7-redis \
    && rm /usr/bin/iconv \
    && cd /tmp \
    && curl -SL http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz | tar -xz -C . \
    && cd libiconv-1.14 \
    && ./configure --prefix=/usr/local \
    && curl -SL https://raw.githubusercontent.com/mxe/mxe/7e231efd245996b886b501dad780761205ecf376/src/libiconv-1-fixes.patch \
    | patch -p1 -u  \
    && make \
    && make install \
    && libtool --finish /usr/local/lib \
    && cd .. \
    && rm -rf libiconv-1.14 \
    && cd / && rm -rf /tmp/* \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/*

ENV LD_PRELOAD /usr/local/lib/preloadable_libiconv.so

COPY php.custom.ini /usr/local/etc/php/conf.d
