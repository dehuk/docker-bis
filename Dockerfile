FROM php:5.6.30-apache

RUN a2enmod rewrite

# Memory Limit
RUN echo "memory_limit=512M" > $PHP_INI_DIR/conf.d/memory-limit.ini

# PHP Core Extensions
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
    && docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

# Extensions bz2
RUN apt-get update \
    && apt-get install -y libbz2-dev \
    && docker-php-ext-configure bz2 \
    && docker-php-ext-install -j$(nproc) bz2

# Extensions bcmath
RUN docker-php-ext-configure bcmath \
    && docker-php-ext-install -j$(nproc) bcmath

# Extensions calendar
RUN docker-php-ext-configure calendar \
    && docker-php-ext-install -j$(nproc) calendar

# Extensions curl
RUN apt-get update \
    && apt install -y curl libcurl3 libcurl3-dev \
    && docker-php-ext-configure curl \
    && docker-php-ext-install -j$(nproc) curl

# Extensions exif
RUN docker-php-ext-configure exif \
    && docker-php-ext-install -j$(nproc) exif

# Extensions gettex
RUN docker-php-ext-configure gettext \
    && docker-php-ext-install -j$(nproc) gettext

# Extensions gmp
RUN apt-get update \
    && apt-get install -y libgmp-dev \
    && ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h \
    && docker-php-ext-configure gmp \
    && docker-php-ext-install -j$(nproc) gmp

# Extensions imap
RUN apt-get update \
    && apt-get install -y libc-client-dev libkrb5-dev \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install -j$(nproc) imap

# Extensions ldap
RUN apt-get update \
    && apt install -y libldap2-dev \
    && ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/libldap.so \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu \
    && docker-php-ext-install -j$(nproc) ldap

# Extensions hash
RUN docker-php-ext-configure hash \
    && docker-php-ext-install -j$(nproc) hash

# Extensions mbstring
RUN docker-php-ext-configure mbstring \
    && docker-php-ext-install -j$(nproc) mbstring

# Extensions pdo
RUN docker-php-ext-configure pdo \
    && docker-php-ext-install -j$(nproc) pdo

# Extensions pdo_mysql
RUN docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
    && docker-php-ext-install -j$(nproc) pdo_mysql

# Extensions mysqli
RUN docker-php-ext-configure mysqli --with-mysqli=mysqlnd \
    && docker-php-ext-install -j$(nproc) mysqli

# Extensions pcntl
RUN docker-php-ext-configure pcntl \
    && docker-php-ext-install -j$(nproc) pcntl

# Extensions sysvmsg
RUN docker-php-ext-configure sysvmsg \
    && docker-php-ext-install -j$(nproc) sysvmsg

# Extensions sysvsem
RUN docker-php-ext-configure sysvsem \
    && docker-php-ext-install -j$(nproc) sysvsem

# Extensions sysvshm
RUN docker-php-ext-configure sysvshm \
    && docker-php-ext-install -j$(nproc) sysvshm

# Extensions zip
RUN apt-get update \
    && apt-get install -y --no-install-recommends zlib1g-dev \
    && rm -r /var/lib/apt/lists/* \
    && docker-php-ext-install -j$(nproc) zip

# Extensions intl
RUN apt-get update \
    && apt-get install -y --no-install-recommends libicu-dev \
    && docker-php-ext-configure intl \
    && docker-php-ext-install -j$(nproc) intl

# Extensions xml
RUN apt-get update \
    && apt-get install -y --no-install-recommends libxml2-dev \
    && docker-php-ext-configure xml \
    && docker-php-ext-install -j$(nproc) xml

# Extensions wddx
RUN docker-php-ext-configure wddx --enable-libxml \
    && docker-php-ext-install wddx

# Extensions xsl
RUN apt-get update \
    && apt-get install -y --no-install-recommends libxslt-dev \
    && docker-php-ext-configure xsl \
    && docker-php-ext-install -j$(nproc) xsl

RUN a2enmod rewrite

# Install utils
RUN apt-get update \
    && apt-get install -y nano git mysql-client wget\
    && rm -r /var/lib/apt/lists/*

# Install composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && chmod +x /usr/local/bin/composer
