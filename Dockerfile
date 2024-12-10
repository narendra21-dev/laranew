# Use an official PHP image as a base image
FROM php:8.2-fpm

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev zip git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

# Install Composer (PHP package manager)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set the working directory in the container
WORKDIR /var/www

# Copy the existing Laravel project into the container
COPY . .

# Install Laravel dependencies with Composer
RUN composer install --no-dev --optimize-autoloader

# Set the file permissions
RUN chown -R www-data:www-data /var/www && chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# Expose port 9000 to the outside world
EXPOSE 9000

# Start PHP-FPM server
CMD ["php-fpm"]
