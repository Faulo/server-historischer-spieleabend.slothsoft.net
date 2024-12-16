FROM faulo/farah:test

RUN Remove-Item -Recurse -Force C:/www/*

COPY . C:/www

RUN composer -d C:/www install --no-interaction --no-dev --optimize-autoloader --classmap-authoritative