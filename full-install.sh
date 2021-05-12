#!/bin/bash

# Args
# 1) domain name you're signing | default: proxy.localhost
# 2) output parent folder for certs | default: /.light-certs/proxy.localhost/*
host_name=${1:-proxy.localhost}
cert_root_path="${2:-"/.light-certs/"}$host_name"
echo -e "configured with \n\t host_name: $host_name \n\t cert_path: $cert_root_path"

# Install light-ca
curl -sL https://github.com/light-river/light-ca/releases/download/latest/light-ca.tar.gz | tar zx && sudo mv ./light-ca /usr/bin/light-ca
sudo light-ca --domains "$host_name"
sudo light-ca --domains "*.$host_name"

# Move certs
sudo mkdir -p $cert_root_path
sudo mv "./$host_name/*" "$cert_root_path"
echo "certs installed at $cert_root_path"

# Install Apache2
sudo apt-get update
sudo apt-get install apache2

# Configure apache2 to run on startup
sudo systemctl stop apache2.service
sudo systemctl start apache2.service
sudo systemctl enable apache2.service
sudo systemctl restart apache2.service

# Install apache proxy modules
sudo a2enmod ssl
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod proxy_balancer
sudo a2enmod proxy_wstunnel
sudo a2enmod proxy_connect
sudo systemctl restart apache2.service

# Copy over template configuration to Apache
sudo cp ./template-configs/default.cfg /etc/apache2/sites-available/Apache2Proxy.conf
sudo a2ensite Apache2Proxy.conf 
sudo systemctl restart apache2.service

# Create symlink for the `edit-proxy` cmd
sudo rm -rf /usr/bin/edit-proxy
sudo ln -s "$(pwd)/links/edit-proxy" /usr/bin/edit-proxy

echo -e "\n\n"
echo -e "\n\tCool, you can now run: \n\n\t\t edit-proxy\n\n\n"
echo -e "\n\tYou should run that command now & replace "example.com" with your domain-name"
