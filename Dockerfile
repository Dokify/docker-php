FROM php:7.4-fpm-alpine

RUN apk --update upgrade \
    && apk add --no-cache autoconf automake make gcc g++ icu-dev rabbitmq-c rabbitmq-c-dev openssh bash \
    && pecl install \
        amqp \
        xdebug \
    && docker-php-ext-install -j$(nproc) \
        bcmath \
        intl \
        pdo_mysql \
        sockets \
    && docker-php-ext-enable \
        xdebug \
        amqp \
    && ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key -N "" \
    && echo 'root:root'|chpasswd \
    && mkdir -p /root/.ssh \
    && touch /root/.ssh/authorized_keys \
    && chmod 0600 -R /root/.ssh \
    && chown root:root -R /root/.ssh

COPY php.custom.ini /usr/local/etc/php/conf.d

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm"]
EXPOSE 22 9000

RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

WORKDIR /app