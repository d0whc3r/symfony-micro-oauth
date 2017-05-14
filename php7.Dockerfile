FROM php:7.0-fpm

RUN apt-get update \
    && apt-get -yq upgrade
RUN apt-get -yq install \
        python-software-properties \
        curl \
        mysql-client \
        libmysqlclient-dev \
        git \
        apt-transport-https \
        ca-certificates \
        zip unzip \
    && docker-php-ext-install mysqli \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /app/server
