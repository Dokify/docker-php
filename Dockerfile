FROM php:7.4-apache

RUN apt update -yq \
    && apt install -yq --no-install-recommends autoconf automake make gcc g++ libicu-dev librabbitmq-dev \
    apt-transport-https \
    ca-certificates \
    gnupg2 \
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

RUN sed -i 's/80/${PORT}/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf

# Configure PHP for development.
# Switch to the production php.ini for production operations.
# RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
# https://hub.docker.com/_/php#configuration
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

# Copy local code to the container image.
# COPY index.php /var/www/html/