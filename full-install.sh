#!/bin/bash

echo -e "This configures the root namespace... you shouldn't run this multiple times"
echo -e "The only prerequistes to installing are \n\t 1. Public facing ipv4 \n\t 2. DNS record pointing a domain name to that ip"

read -p "Do you want to proceed? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
	    exit 1
fi
echo -e "Cool. "


#Add SSL certificates
sudo snap install core; sudo snap refresh core
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
sudo certbot certonly --standalone

#Validate automatic renewal
sudo certbot renew --dry-run

#Install Apache2
sudo apt-get update
sudo apt-get install apache2

#Configure apache2 to run on startup
sudo systemctl stop apache2.service
sudo systemctl start apache2.service
sudo systemctl enable apache2.service
sudo systemctl stop apache2.service

#Install apache proxy modules
sudo a2enmod ssl
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod proxy_balancer
sudo a2enmod proxy_wstunnel
sudo a2enmod proxy_connect
sudo systemctl restart apache2

#Copy over template configuration to Apache
sudo cp ./template-configs/default.cfg /etc/apache2/sites-available/Apache2Proxy.conf
sudo a2ensite Apache2Proxy.conf 
sudo systemctl restart apache2.service

ln -s "$(pwd)/links/edit-proxy" ~/edit-proxy
chmod +x ~/edit-proxy

echo -e "\nCool, you can run ~/edit-proxy to change the configuration and restart the proxy with one command now"
echo -e "Go there and replace the example.com domain with your own"


