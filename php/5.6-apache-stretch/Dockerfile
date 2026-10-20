# syntax=docker/dockerfile:1
FROM composer:2.2.24 AS composer_stage

FROM php:5.6.40-apache-stretch

LABEL org.opencontainers.image.title="PHP 5.6 Apache (Legacy Hardened - Brazil TZ)" \
      org.opencontainers.image.description="Hardened PHP 5.6.40 Apache container pre-configured for America/Sao_Paulo and pt_BR.UTF-8" \
      org.opencontainers.image.vendor="Erik Tonon" \
      org.opencontainers.image.authors="Erik Tonon <https://eriktonon.com>" \
      org.opencontainers.image.source="https://github.com/eriktonon/docker-images" \
      org.opencontainers.image.licenses="MIT"

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
    && sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf \
    && sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf \
    && { \
        echo "ServerTokens Prod"; \
        echo "ServerSignature Off"; \
        echo "<IfModule mod_headers.c>"; \
        echo "    Header always set X-Content-Type-Options \"nosniff\""; \
        echo "    Header always set X-Frame-Options \"SAMEORIGIN\""; \
        echo "</IfModule>"; \
    } > /etc/apache2/conf-available/security-hardening.conf \
    && a2enmod rewrite headers \
    && a2enconf security-hardening \
    && mkdir -p "${APACHE_DOCUMENT_ROOT}" \
    && chown -R www-data:www-data /var/www /var/run/apache2 /var/lock/apache2 /var/log/apache2

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
    CMD curl -fsS http://127.0.0.1:80/ || exit 1

USER www-data
