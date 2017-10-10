FROM php:5.6.30-apache

RUN a2enmod rewrite

# Memory Limit
RUN echo "memory_limit=512M" > $PHP_INI_DIR/conf.d/memory-limit.ini

RUN set -ex \
	&& buildDeps=' \
		libjpeg62-turbo-dev \
		libpng12-dev \
		libpq-dev \
	' \
	&& apt-get update && apt-get install -y --no-install-recommends $buildDeps && rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd \
		--with-jpeg-dir=/usr \
		--with-png-dir=/usr \
	&& docker-php-ext-install -j "$(nproc)" gd bcmath dba mbstring pdo pdo_mysql pdo_pgsql calendar zip exif mysqli \
	&& apt-mark manual \
		libjpeg62-turbo \
		libpq5 \
	&& apt-get purge -y --auto-remove $buildDeps

# Install intl
RUN apt-get update \
	&& apt-get install -y libicu-dev \
	&& docker-php-ext-configure intl \
	&& docker-php-ext-install intl

# Extensions xml
RUN apt-get update \
    && apt-get install -y --no-install-recommends libxml2-dev \
    && docker-php-ext-configure xml \
    && docker-php-ext-install -j$(nproc) xml

# Extensions wddx
RUN docker-php-ext-configure wddx --enable-libxml \
    && docker-php-ext-install wddx

RUN apt-get update && apt-get install -y mysql-client
