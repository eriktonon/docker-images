# PHP 7.3.11 Apache (Legacy Hardened - Brazil TZ)

- **Base Image**: `php:7.3.11-apache-stretch`
- **Timezone / Locale**: `America/Sao_Paulo` (`pt_BR.UTF-8`)
- **Included Extensions**: `pdo_pgsql`, `pgsql`, `pdo_mysql`, `mysqli`, `sqlsrv`, `pdo_sqlsrv`, `pdo_dblib`, `soap`, `intl`, `mbstring`, `bcmath`, `gd`, `imagick`, `zip`, `sockets`, `xdebug` (trigger-only)
- **Composer**: `2.8.6` (pinned multi-stage)
- **Runtime User**: `www-data` (non-root)
