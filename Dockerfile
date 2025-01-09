ARG PHP_VERSION=8.0
FROM faulo/farah:${PHP_VERSION}

# Linux tools
RUN apt update && apt upgrade -y

# Website
COPY --chown=www-data:www-data . .
RUN chmod 777 .

# Composer
USER www-data
RUN composer update --no-interaction --no-dev --optimize-autoloader --classmap-authoritative