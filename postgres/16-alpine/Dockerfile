# syntax=docker/dockerfile:1
FROM postgres:16.8-alpine3.21

LABEL org.opencontainers.image.title="PostgreSQL 16.8 Alpine (Enterprise Hardened - Brazil TZ)" \
      org.opencontainers.image.description="Hardened PostgreSQL 16.8 Alpine container pre-configured for America/Sao_Paulo and pt_BR.UTF-8" \
      org.opencontainers.image.vendor="Erik Tonon" \
      org.opencontainers.image.authors="Erik Tonon <https://eriktonon.com>" \
      org.opencontainers.image.source="https://github.com/eriktonon/docker-images" \
      org.opencontainers.image.licenses="MIT"

ENV TZ=America/Sao_Paulo \
    PGTZ=America/Sao_Paulo \
    LANG=pt_BR.UTF-8 \
    LC_ALL=pt_BR.UTF-8

RUN apk upgrade --no-cache \
    && apk add --no-cache tzdata \
    && cp /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo "${TZ}" > /etc/timezone

EXPOSE 5432

HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
    CMD pg_isready -U "${POSTGRES_USER:-postgres}" || exit 1

USER postgres
