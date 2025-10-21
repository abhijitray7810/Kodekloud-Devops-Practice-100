# Use ubuntu:24.04 as the base image
FROM ubuntu:24.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install apache2
RUN apt-get update && apt-get install -y \
    apache2 \
    && rm -rf /var/lib/apt/lists/*

# Change Apache to listen on port 8087
# Update ports.conf to change Listen directive from 80 to 8087
RUN sed -i 's/Listen 80/Listen 8087/g' /etc/apache2/ports.conf

# Update the default virtual host configuration to use port 8087
RUN sed -i 's/<VirtualHost \*:80>/<VirtualHost *:8087>/g' /etc/apache2/sites-available/000-default.conf

# Create a simple test page to verify Apache is working
RUN echo '<html><body><h1>Apache2 on Ubuntu 24.04 - Port 8087</h1><p>Server is running successfully!</p></body></html>' > /var/www/html/index.html

# Expose port 8087
EXPOSE 8087

# Start Apache in the foreground
CMD ["apache2ctl", "-D", "FOREGROUND"]
