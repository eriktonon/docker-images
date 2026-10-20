# syntax=docker/dockerfile:1
FROM postgres:11.5

LABEL org.opencontainers.image.title="PostgreSQL 11.5 (Legacy Hardened - Brazil TZ)" \
      org.opencontainers.image.description="PostgreSQL 11.5 container pre-configured for America/Sao_Paulo and pt_BR.UTF-8" \
      org.opencontainers.image.vendor="Erik Tonon" \
      org.opencontainers.image.authors="Erik Tonon <https://eriktonon.com>" \
      org.opencontainers.image.source="https://github.com/eriktonon/docker-images" \
      org.opencontainers.image.licenses="MIT"

ENV TZ=America/Sao_Paulo \
    LANG=pt_BR.UTF-8 \
    LANGUAGE=pt_BR:pt:en \
    LC_ALL=pt_BR.UTF-8

RUN sed -i 's/deb.debian.org/archive.debian.org/g; s|security.debian.org/debian-security|archive.debian.org/debian-security|g; /stretch-updates/d; /buster-updates/d' /etc/apt/sources.list \
    && apt-get -o Acquire::Check-Valid-Until=false update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        locales \
        tzdata \
    && sed -i '/pt_BR.UTF-8/s/^# //g' /etc/locale.gen \
    && locale-gen pt_BR.UTF-8 \
    && ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo "${TZ}" > /etc/timezone \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 5432

HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
    CMD pg_isready -U "${POSTGRES_USER:-postgres}" || exit 1

USER postgres
