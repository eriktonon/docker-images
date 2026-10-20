# Security Policy & Supply-Chain Hardening

## Build-to-Manage & Shift-Left Security

All container definitions in `eriktonon/docker-images` follow **Build-to-Manage** and **OWASP / CIS Docker Benchmark** engineering standards:

1. **Pinned Upstream Digests & Semantic Versions**: No mutable `:latest` base images in `FROM` instructions or `COPY --from` stages.
2. **Cryptographic Checksum Verification (`CWE-494`)**: All PECL extensions (`redis`, `xdebug`, `imagick`, `sqlsrv`, `pdo_sqlsrv`) are fetched via HTTPS with explicit version arguments and verified against SHA-256 digests (`sha256sum -c -`) prior to local compilation.
3. **Non-Root Runtime Execution (`CWE-250`)**: All images drop root privileges and execute under dedicated least-privilege accounts (`www-data`, `postgres`, `mysql`).
4. **Hardened Debug & Runtime Profiles (`CWE-918`)**:
   - Production `php.ini` baseline (`expose_php = Off`, `display_errors = Off`, `session.cookie_httponly = 1`, `session.use_strict_mode = 1`).
   - Legacy Xdebug configurations enforce `xdebug.discover_client_host = 0` and `xdebug.start_with_request = trigger` to eliminate DBGp connect-back SSRF/RCE vectors.
5. **Immutable CI/CD Supply Chain (`CWE-829`)**: All third-party GitHub Actions in `.github/workflows/ci-cd.yml` are pinned to full 40-character commit SHAs.
6. **Operational Readiness Probes**: Every image declares a deterministic `HEALTHCHECK` (`php-fpm -t`, `pg_isready`, `mysqladmin ping`, or HTTP loopback probe).

## Supported Tracks

| Family | Active Enterprise Track (Recommended) | Legacy Compatibility Track (Maintained for Brownfield) |
|---|---|---|
| **PHP (`eriktonon/php`)** | `8.4-fpm-alpine`, `8.4-apache-bookworm`, `8.3-fpm-alpine`, `8.2-fpm-alpine` | `8.0.0`, `7.4.7`, `7.3.x`, `7.2.25`, `7.1.32`, `7.0.33`, `5.6` |
| **PostgreSQL (`eriktonon/postgres`)** | `17-alpine`, `16-alpine` | `12.0`, `11.5`, `9.6.15` |
| **MySQL (`eriktonon/mysql`)** | `8.4-lts`, `8.0` (`8.0.41`) | `8.0.18`, `5.7.27` |
| **phpMyAdmin (`eriktonon/phpmyadmin`)** | `5.2` (`5.2.2-apache`) | `latest` (pinned to `5.2.2-apache`) |

## Reporting a Vulnerability

Please report security issues directly via [eriktonon.com](https://eriktonon.com) or by opening a private security advisory on GitHub.
