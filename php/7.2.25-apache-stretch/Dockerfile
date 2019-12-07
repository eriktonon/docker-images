FROM php:7.2.25-apache-stretch

MAINTAINER Erik Tonon <https://www.linkedin.com/in/erik-tonon-83817b145/>

RUN apt-get update && apt-get install -y \
    git \
    zlib1g-dev \
    unzip \
    unixodbc \
    unixodbc-dev \
    freetds-dev \
    freetds-bin \
    tdsodbc \
    libxml2-dev \
    libicu-dev \
    locales-all \
    task-brazilian-portuguese \
    ghostscript \
    libaio-dev \
    unixodbc \
    tdsodbc \
    libzip-dev \
    && docker-php-ext-install zip \
    && docker-php-ext-install sockets


# Set timezone
RUN rm /etc/localtime &&\
    ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime &&\
    "date"

# Oracle instantclient
# copy oracle files
ADD oracle/instantclient-basic-linux.x64-12.1.0.2.0.zip /tmp/
ADD oracle/instantclient-sdk-linux.x64-12.1.0.2.0.zip /tmp/
ADD oracle/instantclient-sqlplus-linux.x64-12.1.0.2.0.zip /tmp/
ENV LD_LIBRARY_PATH /usr/local/instantclient
ENV TNS_ADMIN       /usr/local/instantclient
ENV ORACLE_BASE     /usr/local/instantclient
ENV ORACLE_HOME     /usr/local/instantclient

# unzip oracle instances
RUN unzip /tmp/instantclient-basic-linux.x64-12.1.0.2.0.zip -d /usr/local/ \
    && unzip /tmp/instantclient-sdk-linux.x64-12.1.0.2.0.zip -d /usr/local/ \
    && unzip /tmp/instantclient-sqlplus-linux.x64-12.1.0.2.0.zip -d /usr/local/

# install pecl
RUN curl -O http://pear.php.net/go-pear.phar \
    ; /usr/local/bin/php -d detect_unicode=0 go-pear.phar

# install oci8
RUN ln -s /usr/local/instantclient_12_1 /usr/local/instantclient \
    && ln -s /usr/local/instantclient/libclntsh.so.12.1 /usr/local/instantclient/libclntsh.so \
    && ln -s /usr/local/instantclient/sqlplus /usr/bin/sqlplus \
    && echo 'instantclient,/usr/local/instantclient' | pecl install oci8 \
    && echo "extension=oci8.so" > /usr/local/etc/php/oci8.ini

# xDEBUG testing
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && echo 'xdebug.remote_enable=on' >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo 'xdebug.remote_host=10.0.75.1' >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo 'xdebug.remote_port=9000' >> /usr/local/etc/php/conf.d/xdebug.ini \
    && a2enmod rewrite

#Postgres Driver
RUN apt-get update && apt-get install -y \
    libpq-dev \
    libpng-dev \
    zip unzip \
    git \
    iputils-ping && \
    docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql && \
    docker-php-ext-install pdo pdo_pgsql pgsql && \
    docker-php-ext-install gd

# Microsoft SQL Server Prerequisites
RUN apt-get -y install unixodbc-dev
RUN pecl install sqlsrv pdo_sqlsrv
RUN docker-php-ext-install bcmath

# Driver Mysql Pdo
RUN docker-php-ext-install pdo pdo_mysql zip 
RUN docker-php-ext-install mysqli

#imagick
RUN export CFLAGS="$PHP_CFLAGS" CPPFLAGS="$PHP_CPPFLAGS" LDFLAGS="$PHP_LDFLAGS"
RUN apt-get install -y --no-install-recommends libmagickwand-dev \
    && pecl install imagick-3.4.3 \
    && docker-php-ext-enable imagick


#Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN a2enmod rewrite \
    && a2enmod headers


# SOAP api extension
RUN docker-php-ext-install soap \
    && docker-php-ext-install pdo intl mbstring \
    && docker-php-ext-configure pdo_dblib --with-libdir=/lib/x86_64-linux-gnu

#XDEBUG
RUN docker-php-ext-install pdo_dblib \
    && docker-php-ext-enable intl mbstring pdo_dblib