ARG PHPVERSION=8.0
FROM webdevops/php:${PHPVERSION}

ARG PHPVERSION
ARG DEBIAN_FRONTEND=noninteractive

ENV LC_ALL en_GB.UTF-8
ENV LANG en_GB.UTF-8
ENV LANGUAGE en_GB.UTF-8

RUN apt update && apt install -yq --no-install-recommends \
        locales \
        libgearman-dev \
        libzip-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libwebp-dev \
        libpng-dev \
        libxml2-dev \
        libxslt-dev \
    && \
    locale-gen en_GB.utf8 en_US.utf8 es_ES.utf8 de_DE.UTF-8 && \
    pecl install \
    xdebug \
    gearman \
    igbinary \
    apcu && \
    docker-php-ext-configure zip && \
    docker-php-ext-enable gearman igbinary && \
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
        zip \
        gettext && \
    pecl uninstall redis && \
    cd /tmp && curl -LO https://pecl.php.net/get/redis \
    && tar xvzf redis \
    && ( \
        cd redis-5.3.7 \
        && phpize \
        && ./configure --enable-redis-igbinary \
        && make && make install \
    ) && \
    apt-get -y clean && \
    apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf /tmp/redis* && \
    rm -rf /var/lib/{apt,dpkg,cache,log}

COPY php.custom.ini /usr/local/etc/php/conf.d
