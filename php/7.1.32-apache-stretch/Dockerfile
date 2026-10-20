# syntax=docker/dockerfile:1
FROM composer:2.2.24 AS composer_stage

FROM php:7.1.32-apache-stretch

LABEL org.opencontainers.image.title="PHP 7.1.32 Apache (Legacy Hardened - Brazil TZ)" \
      org.opencontainers.image.description="Hardened PHP 7.1.32 Apache container pre-configured for America/Sao_Paulo and pt_BR.UTF-8" \
      org.opencontainers.image.vendor="Erik Tonon" \
      org.opencontainers.image.authors="Erik Tonon <https://eriktonon.com>" \
      org.opencontainers.image.source="https://github.com/eriktonon/docker-images" \
      org.opencontainers.image.licenses="MIT"

ARG XDEBUG_VERSION=2.9.8
ARG XDEBUG_SHA256=f555b6cc58d96c9965af942d22e0f1818b7a477a410c76b1ab0eebe85a762f8a

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
        git \
        libaio-dev \
        libicu-dev \
        libxml2-dev \
        libzip-dev \
        locales \
        tzdata \
        unzip \
        zlib1g-dev \
    && sed -i '/pt_BR.UTF-8/s/^# //g' /etc/locale.gen \
    && locale-gen pt_BR.UTF-8 \
    && ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo "${TZ}" > /etc/timezone \
    && docker-php-ext-configure pdo_dblib --with-libdir=/lib/x86_64-linux-gnu \
    && docker-php-ext-install -j"$(nproc)" \
        intl \
        mbstring \
        mysqli \
        pdo \
        pdo_dblib \
        pdo_mysql \
        soap \
        zip \
    && curl -fsSL "https://pecl.php.net/get/xdebug-${XDEBUG_VERSION}.tgz" -o /tmp/xdebug.tgz \
    && echo "${XDEBUG_SHA256}  /tmp/xdebug.tgz" | sha256sum -c - \
    && pecl install /tmp/xdebug.tgz \
    && docker-php-ext-enable xdebug \
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
        echo "xdebug.discover_client_host = 0"; \
        echo "xdebug.client_host = host.docker.internal"; \
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
