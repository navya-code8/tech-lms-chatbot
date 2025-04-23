FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    nginx \
    supervisor \
    && docker-php-ext-install pdo pdo_mysql

COPY . /var/www
WORKDIR /var/www

# Fix permissions if needed
RUN mkdir -p /var/log/nginx /var/log/php-fpm

# Copy nginx config
COPY docker/nginx/default.conf /etc/nginx/conf.d/default.conf

# Copy supervisord config
COPY supervisord.conf /etc/supervisord.conf

EXPOSE 80

RUN chown -R www-data:www-data /var/www \
&& chmod -R 775 /var/www/storage

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
