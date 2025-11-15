## Written for the "latest" version of osticket (v1.18-git)

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

# Install APCu extension for better performance
RUN pecl install apcu \
    && docker-php-ext-enable apcu

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

# Rename the sample file include/ost-sampleconfig.php to ost-config.php
RUN cp /var/www/html/include/ost-sampleconfig.php /var/www/html/include/ost-config.php

# Grant write access to ost-config.php
RUN chmod 0666 /var/www/html/include/ost-config.php

# Expose port 80
EXPOSE 80

# Start apache
CMD ["apache2-foreground"]
