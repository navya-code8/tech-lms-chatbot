FROM php:8.2-cli

WORKDIR /app

COPY . .

RUN apt-get update && apt-get install -y unzip
RUN curl -sS https://getcomposer.org/installer | php
RUN php composer.phar install --no-dev

EXPOSE 8080

CMD ["php", "-S", "0.0.0.0:8080", "-t", "public"]
