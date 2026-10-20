# syntax=docker/dockerfile:1
FROM composer:2.8.6 AS composer_stage

FROM php:8.2.28-fpm-alpine3.21 AS builder

ARG REDIS_VERSION=6.1.0
ARG REDIS_SHA256=f10405f639fe415e9ed4ec99538e72c90694d8dbd62868edcfcd6a453466b48c

RUN apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        curl \
        freetype-dev \
        icu-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        libpq-dev \
        libxml2-dev \
        libzip-dev \
        linux-headers \
        oniguruma-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j"$(nproc)" \
        bcmath \
        gd \
        intl \
        mbstring \
        mysqli \
        opcache \
        pcntl \
        pdo \
        pdo_mysql \
        pdo_pgsql \
        pgsql \
        soap \
        sockets \
        zip \
    && curl -fsSL "https://pecl.php.net/get/redis-${REDIS_VERSION}.tgz" -o /tmp/redis.tgz \
    && echo "${REDIS_SHA256}  /tmp/redis.tgz" | sha256sum -c - \
    && pecl install /tmp/redis.tgz \
    && docker-php-ext-enable redis \
    && rm -rf /tmp/*

FROM php:8.2.28-fpm-alpine3.21 AS runtime

LABEL org.opencontainers.image.title="PHP 8.2 FPM Alpine (Enterprise Hardened - Brazil TZ)" \
      org.opencontainers.image.description="Multi-stage hardened PHP 8.2.28 FPM Alpine image with OPcache JIT, PGSQL, MySQL, Redis and America/Sao_Paulo TZ" \
      org.opencontainers.image.vendor="Erik Tonon" \
      org.opencontainers.image.authors="Erik Tonon <https://eriktonon.com>" \
      org.opencontainers.image.source="https://github.com/eriktonon/docker-images" \
      org.opencontainers.image.licenses="MIT"

ENV TZ=America/Sao_Paulo \
    LANG=pt_BR.UTF-8 \
    LANGUAGE=pt_BR:pt:en \
    LC_ALL=pt_BR.UTF-8

RUN apk upgrade --no-cache \
    && apk add --no-cache \
        ca-certificates \
        curl \
        fcgi \
        freetype \
        icu-libs \
        libjpeg-turbo \
        libpng \
        libpq \
        libxml2 \
        libzip \
        oniguruma \
        tzdata \
    && cp /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo "${TZ}" > /etc/timezone

COPY --from=builder /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/
COPY --from=builder /usr/local/etc/php/conf.d/ /usr/local/etc/php/conf.d/
COPY --from=composer_stage /usr/bin/composer /usr/local/bin/composer

RUN cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
    && { \
        echo "date.timezone = ${TZ}"; \
        echo "expose_php = Off"; \
        echo "display_errors = Off"; \
        echo "log_errors = On"; \
        echo "memory_limit = 256M"; \
        echo "opcache.enable = 1"; \
        echo "opcache.enable_cli = 1"; \
        echo "opcache.jit_buffer_size = 64M"; \
        echo "opcache.jit = 1255"; \
        echo "opcache.validate_timestamps = 0"; \
        echo "session.cookie_httponly = 1"; \
        echo "session.cookie_secure = 1"; \
        echo "session.use_strict_mode = 1"; \
    } > "$PHP_INI_DIR/conf.d/99-enterprise-hardening.ini" \
    && chown -R www-data:www-data /var/www

WORKDIR /var/www/html

EXPOSE 9000

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD php-fpm -t || exit 1

USER www-data
