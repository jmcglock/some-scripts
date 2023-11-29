#!/bin/bash

# Obtain elevated privileges
sudo -s

# Update package list and install apache2
apt-get update && apt-get upgrade -y
apt-get install -y apache2

# Enable required Apache modules
a2enmod proxy proxy_http

# Create a directory to store ISO files and set permissions
mkdir -p /var/www/html/iso
chown -R www-data:www-data /var/www/html/iso
chmod -R 755 /var/www/html/iso

# Create a virtual host configuration for serving ISO files
cat > /etc/apache2/sites-available/iso.conf << EOL
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html/iso

    ErrorLog \${APACHE_LOG_DIR}/iso-error.log
    CustomLog \${APACHE_LOG_DIR}/iso-access.log combined

    ProxyPreserveHost On
    ProxyPass / http://127.0.0.1:80/
    ProxyPassReverse / http://127.0.0.1:80/
</VirtualHost>
EOL

# Enable the ISO virtual host
a2ensite iso

# Restart Apache
systemctl restart apache2

# Print the message
echo "Apache is now serving ISO files from /var/www/html/iso"

#Define the base URL
BASE_URL="https://releases.rancher.com/harvester/v1.2.1/harvester-v1.2.1"

#Download the ISO files
wget -P /var/www/html/iso ${BASE_URL}-amd64.iso
wget -P /var/www/html/iso ${BASE_URL}-initrd-amd64
wget -P /var/www/html/iso ${BASE_URL}-vmlinuz-amd64
wget -P /var/www/html/iso ${BASE_URL}-rootfs-amd64.squashfs

#Print the message
echo "ISO files downloaded to /var/www/html/iso"