FROM php:5.6-apache-stretch
MAINTAINER eriktonon@gmail.com <https://www.linkedin.com/in/erik-tonon-83817b145/>

RUN apt-get update && apt-get install -y \
    wget \
    git \
    unzip \
    curl \
    libaio-dev \
    libzip-dev \
    libxml2-dev \
    freetds-dev \
    freetds-bin \
    libaio-dev \
    libicu-dev \
    libzip-dev \
    locales-all \
    task-brazilian-portuguese 

#Set timezone Brazil
RUN rm /etc/localtime &&\
    ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime &&\
    "date"
#Install pecl
RUN curl -O http://pear.php.net/go-pear.phar \
    ; /usr/local/bin/php -d detect_unicode=0 go-pear.phar
# DRIVER MYSQL PDO
 RUN docker-php-ext-install pdo pdo_mysql zip 
 RUN docker-php-ext-install mysqli

 #Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

#SOAP PHP EXT
RUN docker-php-ext-install soap \
    && docker-php-ext-install pdo intl mbstring \
    && docker-php-ext-configure pdo_dblib --with-libdir=/lib/x86_64-linux-gnu

RUN a2enmod rewrite \
    && a2enmod headers