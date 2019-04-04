ARG PHP_VERSION
FROM php:${PHP_VERSION}-fpm

ARG PHP_XDEBUG
ARG PHP_SWOOLE
ARG PHP_REDIS

COPY ./conf/sources.list /etc/apt/sources.list.tmp
RUN mv /etc/apt/sources.list.tmp /etc/apt/sources.list
RUN apt-get update

# Install extensions from source
COPY ./extensions /tmp/extensions
RUN chmod +x /tmp/extensions/install.sh \
    && /tmp/extensions/install.sh \
    && rm -rf /tmp/extensions

RUN apt install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install $mc gd \
    && :\
    && apt-get install -y libicu-dev \
    && docker-php-ext-install $mc intl \
    && :\
    && apt-get install -y libbz2-dev \
    && docker-php-ext-install $mc bz2 \
    && :\
    && apt-get install -y --no-install-recommends libzip-dev \
    && rm -r /var/lib/apt/lists/* \
    && :\
    && docker-php-ext-install $mc zip \
    && docker-php-ext-install $mc pcntl \
    && docker-php-ext-install $mc pdo_mysql \
    && docker-php-ext-install $mc mysqli \
    && docker-php-ext-install $mc mbstring \
    && docker-php-ext-install $mc exif \
    && docker-php-ext-install $mc sockets


# 镜像信息
LABEL Author="Leo"
LABEL Version="1.0.25-fpm"
LABEL Description="PHP FPM 7.2 镜像. All extensions."
