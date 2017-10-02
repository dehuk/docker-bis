FROM php:5.6.30-apache

RUN a2enmod rewrite

# Memory Limit
RUN echo "memory_limit=512M" > $PHP_INI_DIR/conf.d/memory-limit.ini

RUN set -ex \
	&& buildDeps=' \
		libjpeg62-turbo-dev \
		libpng12-dev \
		libpq-dev \
		libmcrypt-dev \
	' \
	&& apt-get update && apt-get install -y --no-install-recommends $buildDeps && rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd \
		--with-jpeg-dir=/usr \
		--with-png-dir=/usr \
	&& docker-php-ext-install -j "$(nproc)" gd mcrypt bcmath dba mbstring pdo pdo_mysql pdo_pgsql calendar zip exif mysqli \
	&& apt-mark manual \
		libjpeg62-turbo \
		libpq5 \
	&& apt-get purge -y --auto-remove $buildDeps

# Install intl
RUN apt-get update && apt-get install -y libicu-dev
RUN pecl install intl
RUN docker-php-ext-install intl

RUN apt-get update \
	&& apt-get install -y libicu-dev \
	&& docker-php-ext-configure intl \
	&& docker-php-ext-install intl

RUN apt-get update && apt-get install -y mysql-client
