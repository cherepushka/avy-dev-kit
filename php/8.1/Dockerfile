FROM php:8.1.5-fpm-alpine

# Install tools required for build stage
RUN apk add --update --no-cache \
    bash curl wget rsync ca-certificates openssl openssh git tzdata openntpd \
    libxrender fontconfig libc6-compat \
    mysql-client gnupg binutils-gold autoconf \
    g++ gcc gnupg libgcc linux-headers make python3 \
    automake libtool tesseract-ocr-dev pkgconfig

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

# Install xdebug
RUN pecl install xdebug \
 && docker-php-ext-enable xdebug

# Install Imagick
RUN apk add --no-cache imagemagick imagemagick-dev
RUN pecl install imagick \
 && docker-php-ext-enable imagick

# Enable XDebug
ADD xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

EXPOSE 9000

# Tesseract install
RUN git clone --depth 1  https://github.com/tesseract-ocr/tesseract.git
RUN cd tesseract \
    ./autogen.sh \
    ./configure \
    ./make \
    make install \
    ldconfig

ENV TESSDATA_PREFIX=/usr/share/tessdata
# installing russian language
RUN wget -O $TESSDATA_PREFIX/rus.traineddata https://github.com/tesseract-ocr/tessdata/raw/main/rus.traineddata