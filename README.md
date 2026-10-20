# Hardened Base Container Images & Multi-Stage Dockerfiles (`eriktonon/*`)

[![CI/CD Pipeline](https://github.com/eriktonon/docker-images/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/eriktonon/docker-images/actions/workflows/ci-cd.yml)
[![Docker Hub PHP Pulls](https://img.shields.io/badge/Docker%20Hub%20%7C%20eriktonon%2Fphp-147k%2B%20pulls-0db7ed?logo=docker&logoColor=white)](https://hub.docker.com/r/eriktonon/php)
[![Docker Hub Postgres Pulls](https://img.shields.io/badge/Docker%20Hub%20%7C%20eriktonon%2Fpostgres-134k%2B%20pulls-0db7ed?logo=docker&logoColor=white)](https://hub.docker.com/r/eriktonon/postgres)
[![Security Gate](https://img.shields.io/badge/Security%20Gate-Strix%20SAST%200%20Vulns-198038?logo=securityscorecard&logoColor=white)](./SECURITY.md)
[![License: MIT](https://img.shields.io/badge/License-MIT-0f62fe.svg)](./LICENSE)

 Production-grade, hardened container images pre-configured for **Brazilian Enterprise Timezones (`America/Sao_Paulo`)**, **UTF-8 Locales (`pt_BR.UTF-8`)**, **Non-Root Execution**, and **Build-to-Manage Readiness Probes**.

With **283,000+ cumulative pulls** on Docker Hub across [`eriktonon/php`](https://hub.docker.com/r/eriktonon/php) and [`eriktonon/postgres`](https://hub.docker.com/r/eriktonon/postgres), this repository maintains both **Modern Enterprise LTS multi-stage images** (PHP 8.2/8.3/8.4 FPM Alpine & Bookworm, PostgreSQL 16/17 Alpine, MySQL 8.4 LTS) and **Hardened Legacy Brownfield images** (PHP 5.6 through 8.0, PostgreSQL 9.6–12, MySQL 5.7–8.0) for enterprise workloads undergoing modernization.

---

## Architecture & Build-to-Manage Principles

Every Dockerfile in this repository enforces strict **Platform Engineering**, **SRE (Build to Manage)**, and **Shift-Left AppSec** controls:

- **Multi-Stage Builds & Minimal Runtime Footprint**: Build dependencies (`$PHPIZE_DEPS`, header libraries, compilers) are isolated in dedicated build stages or purged in single-layer transactions (`--no-install-recommends` + `rm -rf /var/lib/apt/lists/*`).
- **Cryptographic Supply-Chain Verification (`CWE-494`)**: All PECL packages (`redis`, `xdebug`, `imagick`, `sqlsrv`, `pdo_sqlsrv`) are downloaded via HTTPS with pinned versions and verified against immutable **SHA-256 checksums** (`sha256sum -c -`) before installation.
- **Least-Privilege Non-Root Execution (`CWE-250`)**: All containers drop `root` privileges at runtime (`USER www-data`, `USER postgres`, `USER mysql`).
- **Deterministic Readiness & Liveness (`HEALTHCHECK`)**: Native container health probes (`php-fpm -t`, `pg_isready`, `mysqladmin ping`, HTTP loopback checks) built into every image metadata layer.
- **Hardened Production Configuration (`CWE-918` / `OWASP A05`)**:
  - PHP uses `php.ini-production` with `expose_php = Off`, `display_errors = Off`, `session.cookie_httponly = 1`, `session.use_strict_mode = 1`, and OPcache JIT enabled on PHP 8.2–8.4.
  - Apache 2.4 enforces `ServerTokens Prod`, `ServerSignature Off`, `X-Content-Type-Options: nosniff`, and `X-Frame-Options: SAMEORIGIN`.
  - Xdebug (where present in legacy brownfield tags) is locked down with `xdebug.discover_client_host = 0` and `xdebug.start_with_request = trigger`.

---

## Container Catalog & Tag Matrix

### 1. PHP (`eriktonon/php`) — 147,690+ Pulls

| Track | Tag / Directory | Base Image | Runtime & Extensions |
|---|---|---|---|
| **Modern LTS** | [`php/8.4-fpm-alpine`](./php/8.4-fpm-alpine/Dockerfile) | `php:8.4.5-fpm-alpine3.21` | Multi-stage FPM, OPcache JIT, Composer 2.8.6, PGSQL, MySQL, Redis 6.1.0, Intl, GD, SOAP, Zip, Bcmath |
| **Modern LTS** | [`php/8.4-apache-bookworm`](./php/8.4-apache-bookworm/Dockerfile) | `php:8.4.5-apache-bookworm` | Hardened Apache 2.4, OPcache JIT, Composer 2.8.6, PGSQL, MySQL, Intl, GD, Sockets, Zip |
| **Modern LTS** | [`php/8.3-fpm-alpine`](./php/8.3-fpm-alpine/Dockerfile) | `php:8.3.19-fpm-alpine3.21` | Multi-stage FPM, OPcache JIT, Composer 2.8.6, PGSQL, MySQL, Redis 6.1.0, Intl, GD, SOAP, Zip, Bcmath |
| **Modern LTS** | [`php/8.2-fpm-alpine`](./php/8.2-fpm-alpine/Dockerfile) | `php:8.2.28-fpm-alpine3.21` | Multi-stage FPM, OPcache JIT, Composer 2.8.6, PGSQL, MySQL, Redis 6.1.0, Intl, GD, SOAP, Zip, Bcmath |
| **Legacy Brownfield** | [`php/8.0.0-apache-buster`](./php/8.0.0-apache-buster/Dockerfile) | `php:8.0.0-apache-buster` | Hardened Apache 2.4, Composer 2.8.6, PGSQL, MySQL, Intl, GD, Zip (`archive.debian.org` patched) |
| **Legacy Brownfield** | [`php/7.4.7-apache-buster`](./php/7.4.7-apache-buster/Dockerfile) | `php:7.4.7-apache-buster` | Hardened Apache 2.4, Composer 2.8.6, PGSQL, MySQL, Intl, GD, Zip (`archive.debian.org` patched) |
| **Legacy Brownfield** | [`php/7.3.19-apache-stretch`](./php/7.3.19-apache-stretch/Dockerfile) | `php:7.3.19-apache-stretch` | Hardened Apache 2.4, PGSQL, MySQL, SQLSRV 5.8.1, FreeTDS/DBLib, Imagick 3.4.4, SOAP, Xdebug 3.1.6 |
| **Legacy Brownfield** | [`php/7.3.12-apache-stretch`](./php/7.3.12-apache-stretch/Dockerfile) | `php:7.3.12-apache-stretch` | Hardened Apache 2.4, PGSQL, MySQL, SQLSRV 5.8.1, FreeTDS/DBLib, Imagick 3.4.4, SOAP, Xdebug 3.1.6 |
| **Legacy Brownfield** | [`php/7.3.11-apache-stretch`](./php/7.3.11-apache-stretch/Dockerfile) | `php:7.3.11-apache-stretch` | Hardened Apache 2.4, PGSQL, MySQL, SQLSRV 5.8.1, FreeTDS/DBLib, Imagick 3.4.4, SOAP, Xdebug 3.1.6 |
| **Legacy Brownfield** | [`php/7.3.10-apache-stretch`](./php/7.3.10-apache-stretch/Dockerfile) | `php:7.3.10-apache-stretch` | Hardened Apache 2.4, PGSQL, MySQL, SQLSRV 5.8.1, FreeTDS/DBLib, Imagick 3.4.4, SOAP, Xdebug 3.1.6 |
| **Legacy Brownfield** | [`php/7.3.9-apache-stretch`](./php/7.3.9-apache-stretch/Dockerfile) | `php:7.3.9-apache-stretch` | Hardened Apache 2.4, PGSQL, MySQL, SQLSRV 5.8.1, FreeTDS/DBLib, Imagick 3.4.4, SOAP, Xdebug 3.1.6 |
| **Legacy Brownfield** | [`php/7.2.25-apache-stretch`](./php/7.2.25-apache-stretch/Dockerfile) | `php:7.2.25-apache-stretch` | Hardened Apache 2.4, PGSQL, MySQL, SQLSRV 5.8.1, FreeTDS/DBLib, Imagick 3.4.4, SOAP, Xdebug 3.1.6 |
| **Legacy Brownfield** | [`php/7.1.32-apache-stretch`](./php/7.1.32-apache-stretch/Dockerfile) | `php:7.1.32-apache-stretch` | Hardened Apache 2.4, Composer 2.2.24 LTS, MySQL, FreeTDS/DBLib, SOAP, Intl, Xdebug 2.9.8 |
| **Legacy Brownfield** | [`php/7.0.33-apache-stretch`](./php/7.0.33-apache-stretch/Dockerfile) | `php:7.0.33-apache-stretch` | Hardened Apache 2.4, Composer 2.2.24 LTS, MySQL, FreeTDS/DBLib, SOAP, Intl, Xdebug 2.7.2 |
| **Legacy Brownfield** | [`php/5.6-apache-stretch`](./php/5.6-apache-stretch/Dockerfile) | `php:5.6.40-apache-stretch` | Hardened Apache 2.4, Composer 2.2.24 LTS, MySQL, FreeTDS/DBLib, SOAP, Intl |

### 2. PostgreSQL (`eriktonon/postgres`) — 134,064+ Pulls

| Track | Tag / Directory | Base Image | Configuration |
|---|---|---|---|
| **Modern LTS** | [`postgres/17-alpine`](./postgres/17-alpine/Dockerfile) | `postgres:17.4-alpine3.21` | `TZ=America/Sao_Paulo`, `PGTZ=America/Sao_Paulo`, `LANG=pt_BR.UTF-8`, `pg_isready` Healthcheck |
| **Modern LTS** | [`postgres/16-alpine`](./postgres/16-alpine/Dockerfile) | `postgres:16.8-alpine3.21` | `TZ=America/Sao_Paulo`, `PGTZ=America/Sao_Paulo`, `LANG=pt_BR.UTF-8`, `pg_isready` Healthcheck |
| **Legacy Brownfield** | [`postgres/12.0`](./postgres/12.0/Dockerfile) | `postgres:12.0` | `TZ=America/Sao_Paulo`, `LANG=pt_BR.UTF-8`, `pg_isready` Healthcheck |
| **Legacy Brownfield** | [`postgres/11.5`](./postgres/11.5/Dockerfile) | `postgres:11.5` | `TZ=America/Sao_Paulo`, `LANG=pt_BR.UTF-8`, `pg_isready` Healthcheck |
| **Legacy Brownfield** | [`postgres/9.6.15`](./postgres/9.6.15/Dockerfile) | `postgres:9.6.15` | `TZ=America/Sao_Paulo`, `LANG=pt_BR.UTF-8`, `pg_isready` Healthcheck |

### 3. MySQL (`eriktonon/mysql`)

| Track | Tag / Directory | Base Image | Configuration |
|---|---|---|---|
| **Modern LTS** | [`mysql/8.4-lts`](./mysql/8.4-lts/Dockerfile) | `mysql:8.4.4` | `TZ=America/Sao_Paulo`, non-root `USER mysql`, `mysqladmin ping` Healthcheck |
| **Modern LTS** | [`mysql/8.0`](./mysql/8.0/Dockerfile) | `mysql:8.0.41` | `TZ=America/Sao_Paulo`, non-root `USER mysql`, `mysqladmin ping` Healthcheck |
| **Legacy Brownfield** | [`mysql/8.0.18`](./mysql/8.0.18/Dockerfile) | `mysql:8.0.18` | `TZ=America/Sao_Paulo`, non-root `USER mysql`, `mysqladmin ping` Healthcheck |
| **Legacy Brownfield** | [`mysql/5.7.27`](./mysql/5.7.27/Dockerfile) | `mysql:5.7.27` | `TZ=America/Sao_Paulo`, non-root `USER mysql`, `mysqladmin ping` Healthcheck |

### 4. phpMyAdmin (`eriktonon/phpmyadmin`)

| Track | Tag / Directory | Base Image | Configuration |
|---|---|---|---|
| **Modern Stable** | [`phpmyadmin/5.2`](./phpmyadmin/5.2/Dockerfile) | `phpmyadmin:5.2.2-apache` | Hardened Apache 2.4 headers, `TZ=America/Sao_Paulo`, `pt_BR.UTF-8`, non-root `USER www-data` |
| **Alias** | [`phpmyadmin/latest`](./phpmyadmin/latest/Dockerfile) | `phpmyadmin:5.2.2-apache` | Pinned to `5.2.2-apache` with Brazilian timezone and hardened runtime |

---

## Quick Start

```bash
# Modern PHP 8.4 FPM Alpine (Multi-Stage, OPcache JIT, America/Sao_Paulo)
docker pull eriktonon/php:8.4-fpm-alpine

# Modern PostgreSQL 17 Alpine (America/Sao_Paulo, pt_BR.UTF-8)
docker pull eriktonon/postgres:17-alpine

# Modern MySQL 8.4 LTS (America/Sao_Paulo)
docker pull eriktonon/mysql:8.4-lts
```

---

## Author & Governance

**Erik Tonon** — Head of Platform Engineering & GenAI @ IBM Consulting | Principal SRE & Build-to-Manage Advisor  
- Website: [eriktonon.com](https://eriktonon.com)  
- LinkedIn: [linkedin.com/in/eriktonon](https://www.linkedin.com/in/eriktonon/)  
- Docker Hub: [hub.docker.com/u/eriktonon](https://hub.docker.com/repositories/eriktonon)
