FROM php:8.2-fpm

# Set non-interactive mode so apt doesn't hang
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies & PHP extensions
RUN apt-get update && apt-get install -y \
    nginx \
    supervisor \
    unzip \
    git \
    curl \
    libzip-dev \
    libonig-dev \
    libxml2-dev \
    && docker-php-ext-install pdo pdo_mysql zip mbstring tokenizer xml \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /var/www

# Copy only composer files first (for caching)
COPY composer.lock composer.json ./

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction --no-progress

# Copy rest of the application
COPY . .

# Permissions (Run AFTER copying everything)
RUN chown -R www-data:www-data /var/www \
    && chmod -R 775 /var/www/storage \
    && chmod -R 775 /var/www/bootstrap/cache

# Copy nginx and supervisor config
COPY docker/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY supervisord.conf /etc/supervisord.conf

# Expose port 80 for web
EXPOSE 80

# Run supervisor (starts php-fpm + nginx)
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
