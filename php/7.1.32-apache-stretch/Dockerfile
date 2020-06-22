FROM php:7.1.32-apache-stretch

MAINTAINER eriktonon@gmail.com <https://www.linkedin.com/in/erik-tonon-83817b145/>

RUN apt-get update && apt-get install -y \
    git \
    zlib1g-dev \
    unzip \
    freetds-dev \
    freetds-bin \
    libxml2-dev \
    libicu-dev \
    locales-all \
    task-brazilian-portuguese \
    libaio-dev \
    libzip-dev \
    curl \
    && docker-php-ext-install zip

#Set timezone Brazil
RUN rm /etc/localtime &&\
    ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime &&\
    "date"
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

#Install pecl
RUN curl -O http://pear.php.net/go-pear.phar \
    ; /usr/local/bin/php -d detect_unicode=0 go-pear.phar

# xDEBUG testing
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && echo 'xdebug.remote_enable=on' >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo 'xdebug.remote_host=10.0.75.1' >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo 'xdebug.remote_port=9000' >> /usr/local/etc/php/conf.d/xdebug.ini \
    && a2enmod rewrite

# DRIVER MYSQL PDO
 RUN docker-php-ext-install pdo pdo_mysql zip 
 RUN docker-php-ext-install mysqli
#Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN a2enmod rewrite \
    && a2enmod headers

#SOAP PHP EXT
RUN docker-php-ext-install soap \
    && docker-php-ext-install pdo intl mbstring \
    && docker-php-ext-configure pdo_dblib --with-libdir=/lib/x86_64-linux-gnu

#XDEBUG
RUN docker-php-ext-install pdo_dblib \
    && docker-php-ext-enable intl mbstring pdo_dblib