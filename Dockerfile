FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git curl libpng-dev libonig-dev libxml2-dev zip unzip nginx supervisor \
    && docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy app code
COPY . /var/www

# Copy Nginx config
COPY docker/nginx/default.conf /etc/nginx/conf.d/default.conf

# Copy supervisord config
COPY supervisord.conf /etc/supervisord.conf

# Laravel dependencies
RUN composer install

# Permissions
RUN chown -R www-data:www-data /var/www && chmod -R 755 /var/www

# Create necessary log directories
RUN mkdir -p /var/log/php-fpm

# Expose port for web
EXPOSE 80

# Start supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

# Set permissions
RUN chown -R www-data:www-data /var/www && chmod -R 755 /var/www

# Make storage and bootstrap/cache directories writable
RUN chmod -R 775 /var/www/storage /var/www/bootstrap/cache
