#!/bin/bash

echo -e "\n\n You should not be configuring multiple proxies per namespace"
echo -e "\n The only prerequistes to installing are \n\t 1. Public facing ipv4 \n\t 2. DNS record pointing a domain name to that ip \n \n "

read -p "Do you want to proceed? ( y/n ) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then 
  exit 1 
fi
echo -e "\n\tCool. \n"

# Create & Register a new SSL certificate
sudo snap install core; sudo snap refresh core
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
sudo certbot certonly --standalone

# Validate automatic renewal
sudo certbot renew --dry-run

# Install Apache2
sudo apt-get update
sudo apt-get install apache2

# Configure apache2 to run on startup
sudo systemctl stop apache2.service
sudo systemctl start apache2.service
sudo systemctl enable apache2.service
sudo systemctl stop apache2.service

# Install apache proxy modules
sudo a2enmod ssl
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod proxy_balancer
sudo a2enmod proxy_wstunnel
sudo a2enmod proxy_connect
sudo systemctl restart apache2

# Copy over template configuration to Apache
sudo cp ./template-configs/default.cfg /etc/apache2/sites-available/Apache2Proxy.conf
sudo a2ensite Apache2Proxy.conf 
sudo systemctl restart apache2.service

# Create symlink for the `edit-proxy` cmd
chmod +x ~/edit-proxy
sudo ln -s "$(pwd)/links/edit-proxy" /usr/bin/edit-proxy

echo -e "\n\n"
echo -e "\n\tCool, you can now run: \n\n\t\t edit-proxy\n\n\n"
echo -e "\n\tYou should run that command now & replace "example.com" with your domain-name"
