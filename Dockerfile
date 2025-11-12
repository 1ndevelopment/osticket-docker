# Base image with Apache, PHP and MySQL support
FROM php:8.2-apache-bookworm

# Install required PHP extensions
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    unzip \
    git \
    libicu-dev \
    libonig-dev \
    libxml2-dev \
    libc-client-dev \
    libkrb5-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install -j$(nproc) gd mysqli intl zip xml mbstring bcmath imap \
    && a2enmod rewrite

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Set osTicket repo as safe directory for git commands
RUN git config --global --add safe.directory /var/www/html/

# Clone osTicket repo
RUN git clone https://github.com/osTicket/osTicket.git /var/www/html/

# Deploy osTicket with setup
RUN php manage.php deploy --setup /var/www/html/

# Fix permissions
RUN chown -R www-data:www-data /var/www/html

# Expose port 80
EXPOSE 80

# Start apache
CMD ["apache2-foreground"]
