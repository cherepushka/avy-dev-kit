FROM php:8.1.5-fpm-alpine

ARG UID
ARG GID

ENV UID=${UID}
ENV GID=${GID}

# Install tools required for build stage
RUN apk add --update --no-cache \
    bash curl wget rsync ca-certificates openssl openssh git tzdata openntpd \
    libxrender fontconfig libc6-compat \
    mysql-client gnupg binutils-gold autoconf \
    g++ gcc gnupg libgcc linux-headers make python3 \
    automake libtool tesseract-ocr-dev pkgconfig \
    nodejs npm

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer \
 && chmod 755 /usr/bin/composer

# Install additional PHP libraries
RUN docker-php-ext-install bcmath pdo_mysql

# Install libraries for compiling GD, then build it
RUN apk add --no-cache freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev \
 && docker-php-ext-install gd \
 && apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev

# Add ZIP archives support
RUN apk add --update --no-cache zlib-dev libzip-dev \
 && docker-php-ext-install zip

# Install Imagick
RUN apk add --no-cache imagemagick imagemagick-dev
RUN pecl install imagick \
 && docker-php-ext-enable imagick

RUN addgroup -g ${GID} --system search-avy-group
RUN adduser -G search-avy-group --system -D -s /bin/sh -u ${UID} search-avy

# Add custom php.ini config
ADD prod_php.ini /usr/local/etc/php/php.ini
ADD www.conf /usr/local/etc/php-fpm.d/www.conf

USER search-avy
EXPOSE 9000
