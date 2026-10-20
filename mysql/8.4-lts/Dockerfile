# syntax=docker/dockerfile:1
FROM mysql:8.4.4

LABEL org.opencontainers.image.title="MySQL 8.4.4 LTS (Enterprise Hardened - Brazil TZ)" \
      org.opencontainers.image.description="Hardened MySQL 8.4.4 LTS container pre-configured for America/Sao_Paulo timezone" \
      org.opencontainers.image.vendor="Erik Tonon" \
      org.opencontainers.image.authors="Erik Tonon <https://eriktonon.com>" \
      org.opencontainers.image.source="https://github.com/eriktonon/docker-images" \
      org.opencontainers.image.licenses="MIT"

ENV TZ=America/Sao_Paulo

RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo "${TZ}" > /etc/timezone

EXPOSE 3306

HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
    CMD mysqladmin ping -h 127.0.0.1 --silent || exit 1

USER mysql
