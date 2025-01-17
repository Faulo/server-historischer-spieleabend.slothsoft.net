ARG PHP_VERSION=8.0
FROM faulo/farah:${PHP_VERSION}

# Website
COPY --chown=www-data:www-data . .
RUN chmod 777 .

# Linux tools
RUN apt update && apt upgrade -y

# Composer
USER www-data
RUN composer update --no-interaction --no-dev --optimize-autoloader --classmap-authoritative