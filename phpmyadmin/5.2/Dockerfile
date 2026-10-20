# syntax=docker/dockerfile:1
FROM phpmyadmin:5.2.2-apache

LABEL org.opencontainers.image.title="phpMyAdmin 5.2.2 (Enterprise Hardened - Brazil TZ)" \
      org.opencontainers.image.description="Hardened phpMyAdmin 5.2.2 container pre-configured for America/Sao_Paulo and pt_BR.UTF-8" \
      org.opencontainers.image.vendor="Erik Tonon" \
      org.opencontainers.image.authors="Erik Tonon <https://eriktonon.com>" \
      org.opencontainers.image.source="https://github.com/eriktonon/docker-images" \
      org.opencontainers.image.licenses="MIT"

ENV TZ=America/Sao_Paulo \
    LANG=pt_BR.UTF-8 \
    LANGUAGE=pt_BR:pt:en \
    LC_ALL=pt_BR.UTF-8

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        locales \
        tzdata \
    && sed -i '/pt_BR.UTF-8/s/^# //g' /etc/locale.gen \
    && locale-gen pt_BR.UTF-8 \
    && ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo "${TZ}" > /etc/timezone \
    && { \
        echo "ServerTokens Prod"; \
        echo "ServerSignature Off"; \
        echo "<IfModule mod_headers.c>"; \
        echo "    Header always set X-Content-Type-Options \"nosniff\""; \
        echo "    Header always set X-Frame-Options \"SAMEORIGIN\""; \
        echo "</IfModule>"; \
    } > /etc/apache2/conf-available/security-hardening.conf \
    && a2enmod headers \
    && a2enconf security-hardening \
    && chown -R www-data:www-data /var/www /var/run/apache2 /var/lock/apache2 /var/log/apache2 /sessions \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
    CMD curl -fsS http://127.0.0.1:80/ || exit 1

USER www-data
