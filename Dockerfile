FROM php:8.2-fpm

# Install system packages and PHP extensions
RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx \
    supervisor \
    libzip-dev \
    zip \
    unzip \
    git \
    curl \
    && docker-php-ext-install pdo pdo_mysql zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /var/www

# Copy composer files first to leverage Docker cache
COPY composer.lock composer.json /var/www/

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer install --no-dev --optimize-autoloader

# Copy the full Laravel app
COPY . /var/www

# Set permissions
RUN mkdir -p /var/log/nginx /var/log/php-fpm \
    && chown -R www-data:www-data /var/www \
    && chmod -R 775 /var/www/storage \
    && chmod -R 775 /var/www/bootstrap/cache

# Optional: if environment is ready, create symbolic link for storage
# RUN php artisan storage:link || true

# Copy nginx and supervisor config
COPY docker/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY supervisord.conf /etc/supervisord.conf

# Expose port 80
EXPOSE 80

# Start supervisor to manage php-fpm and nginx
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
