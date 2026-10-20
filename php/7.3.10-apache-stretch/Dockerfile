# syntax=docker/dockerfile:1
FROM composer:2.8.6 AS composer_stage

FROM php:7.3.10-apache-stretch

LABEL org.opencontainers.image.title="PHP 7.3.10 Apache Enterprise (Legacy Hardened - Brazil TZ)" \
      org.opencontainers.image.description="Hardened PHP 7.3.10 Apache container with PGSQL, MySQL, SQLSRV, Imagick, SOAP and America/Sao_Paulo TZ" \
      org.opencontainers.image.vendor="Erik Tonon" \
      org.opencontainers.image.authors="Erik Tonon <https://eriktonon.com>" \
      org.opencontainers.image.source="https://github.com/eriktonon/docker-images" \
      org.opencontainers.image.licenses="MIT"

ARG XDEBUG_VERSION=3.1.6
ARG XDEBUG_SHA256=f0c4f8d9b5ef1d187fb0bf20780b4f85a6071c2b7a98d84d15ca29a57eb265a3
ARG IMAGICK_VERSION=3.4.4
ARG IMAGICK_SHA256=8dd7aa7eb2a1c9a0bf03a256414ef0d562d9f30d62a50d2a8b099b8d42fa7e72
ARG SQLSRV_VERSION=5.8.1
ARG SQLSRV_SHA256=c8e5c4a82a4dc7062ef9e5367bc1b308a49c9d34319d561b26b7549803f7a53f
ARG PDO_SQLSRV_SHA256=b1eb26a74bd6c21abeb27911dc406ca2b36cd97ef9ff4c5bb917a656ca670547

ENV TZ=America/Sao_Paulo \
    LANG=pt_BR.UTF-8 \
    LANGUAGE=pt_BR:pt:en \
    LC_ALL=pt_BR.UTF-8 \
    APACHE_DOCUMENT_ROOT=/var/www/html/public

RUN sed -i 's/deb.debian.org/archive.debian.org/g; s|security.debian.org/debian-security|archive.debian.org/debian-security|g; /stretch-updates/d' /etc/apt/sources.list \
    && apt-get -o Acquire::Check-Valid-Until=false update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        freetds-bin \
        freetds-dev \
        ghostscript \
        git \
        libaio-dev \
        libicu-dev \
        libmagickwand-dev \
        libpng-dev \
        libpq-dev \
        libxml2-dev \
        libzip-dev \
        locales \
        tdsodbc \
        tzdata \
        unixodbc \
        unixodbc-dev \
        unzip \
        zlib1g-dev \
    && sed -i '/pt_BR.UTF-8/s/^# //g' /etc/locale.gen \
    && locale-gen pt_BR.UTF-8 \
    && ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo "${TZ}" > /etc/timezone \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-configure pdo_dblib --with-libdir=/lib/x86_64-linux-gnu \
    && docker-php-ext-install -j"$(nproc)" \
        bcmath \
        gd \
        intl \
        mbstring \
        mysqli \
        pdo \
        pdo_dblib \
        pdo_mysql \
        pdo_pgsql \
        pgsql \
        soap \
        sockets \
        zip \
    && curl -fsSL "https://pecl.php.net/get/xdebug-${XDEBUG_VERSION}.tgz" -o /tmp/xdebug.tgz \
    && echo "${XDEBUG_SHA256}  /tmp/xdebug.tgz" | sha256sum -c - \
    && pecl install /tmp/xdebug.tgz \
    && curl -fsSL "https://pecl.php.net/get/imagick-${IMAGICK_VERSION}.tgz" -o /tmp/imagick.tgz \
    && echo "${IMAGICK_SHA256}  /tmp/imagick.tgz" | sha256sum -c - \
    && pecl install /tmp/imagick.tgz \
    && curl -fsSL "https://pecl.php.net/get/sqlsrv-${SQLSRV_VERSION}.tgz" -o /tmp/sqlsrv.tgz \
    && echo "${SQLSRV_SHA256}  /tmp/sqlsrv.tgz" | sha256sum -c - \
    && pecl install /tmp/sqlsrv.tgz \
    && curl -fsSL "https://pecl.php.net/get/pdo_sqlsrv-${SQLSRV_VERSION}.tgz" -o /tmp/pdo_sqlsrv.tgz \
    && echo "${PDO_SQLSRV_SHA256}  /tmp/pdo_sqlsrv.tgz" | sha256sum -c - \
    && pecl install /tmp/pdo_sqlsrv.tgz \
    && docker-php-ext-enable xdebug imagick sqlsrv pdo_sqlsrv \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY --from=composer_stage /usr/bin/composer /usr/local/bin/composer

RUN cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
    && { \
        echo "date.timezone = ${TZ}"; \
        echo "expose_php = Off"; \
        echo "display_errors = Off"; \
        echo "log_errors = On"; \
        echo "session.cookie_httponly = 1"; \
        echo "session.use_strict_mode = 1"; \
    } > "$PHP_INI_DIR/conf.d/99-hardening.ini" \
    && { \
        echo "xdebug.mode = develop,debug"; \
        echo "xdebug.discover_client_host = 0"; \
        echo "xdebug.client_host = host.docker.internal"; \
        echo "xdebug.client_port = 9003"; \
        echo "xdebug.start_with_request = trigger"; \
    } > "$PHP_INI_DIR/conf.d/98-xdebug-hardened.ini" \
    && sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf \
    && sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf \
    && a2enmod rewrite headers \
    && mkdir -p "${APACHE_DOCUMENT_ROOT}" \
    && chown -R www-data:www-data /var/www /var/run/apache2 /var/lock/apache2 /var/log/apache2

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
    CMD curl -fsS http://127.0.0.1:80/ || exit 1

USER www-data
