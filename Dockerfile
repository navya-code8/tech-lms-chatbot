# Use a PHP base image
FROM php:8.1-cli

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libxml2-dev \
    git \
    curl \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && docker-php-ext-install xml

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set the working directory
WORKDIR /var/www

# Add the laravel user and set permissions
RUN useradd -m laravel && chown -R laravel:laravel /var/www

# Copy the composer files
COPY composer.json composer.lock ./

# Copy the entire Laravel application
COPY . /var/www

# Install dependencies with Composer
RUN mkdir -p /var/www/.composer \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/var/www/.composer --filename=composer \
    && /var/www/.composer/composer install --no-dev --optimize-autoloader

# Set the user to the newly created laravel user
USER laravel

# Expose the necessary port
EXPOSE 9000

# Command to run PHP built-in server (optional, for testing purposes)
CMD ["php", "-S", "0.0.0.0:9000", "-t", "/var/www/public"]
