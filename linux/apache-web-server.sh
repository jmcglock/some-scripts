#!/bin/bash

# Update package list and install apache2
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y apache2

# Enable required Apache modules
sudo a2enmod proxy
sudo a2enmod proxy_http

# Create a directory to store ISO files
sudo mkdir -p /var/www/html/iso

# Set permissions for the ISO directory
sudo chown -R www-data:www-data /var/www/html/iso
sudo chmod -R 755 /var/www/html/iso

# Create a virtual host configuration for serving ISO files
sudo bash -c "cat > /etc/apache2/sites-available/iso.conf << EOL
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
"

# Enable the ISO virtual host and restart Apache
sudo a2ensite iso
sudo systemctl restart apache2

# Print the message
echo "Apache is now serving ISO files from /var/www/html/iso"

#Download the ISO files
sudo wget -P /var/www/html/iso https://releases.rancher.com/harvester/v1.1.1/harvester-v1.1.1-amd64.iso
sudo wget -P /var/www/html/iso https://releases.rancher.com/harvester/v1.1.1/harvester-v1.1.1-initrd-amd64
sudo wget -P /var/www/html/iso https://releases.rancher.com/harvester/v1.1.1/harvester-v1.1.1-vmlinuz-amd64
sudo wget -P /var/www/html/iso https://releases.rancher.com/harvester/v1.1.1/harvester-v1.1.1-rootfs-amd64.squashfs

#Print the message
echo "ISO files downloaded to /var/www/html/iso"