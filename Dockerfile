ARG PHP_VERSION=8.0
FROM faulo/farah:${PHP_VERSION}

COPY . ${WORKDIR}

RUN composer update --no-interaction --no-dev --optimize-autoloader --classmap-authoritative