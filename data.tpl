#!/bin/bash

sudo apt update -y
sudo apt-get install nginx -y
sudo apt-get install php7.2 php7.2-cli php7.2-fpm php7.2-mysql php7.2-json php7.2-opcache php7.2-mbstring php7.2-xml php7.2-gd php7.2-curl -y
sudo apt-get install cifs-utils -y

echo -e "#testen
<?php
define('DB_NAME', '${dbname}');
define('DB_USER', '${dbuser}');
define('DB_PASSWORD', '${dbpassword}');
define('DB_HOST', '${dbadres}');
\$table_prefix = 'wp_';
if ( ! defined( 'ABSPATH' ) ) {
  define( 'ABSPATH', __DIR__ . '/' );
}
require_once ABSPATH . 'wp-settings.php';
?>
#testen" >> /tmp/wp-config.php

echo -e "#Testen of dit werkt
server {
            listen 80;
            root /var/www/html/wordpress/public_html;
            index index.php index.html;
            server_name SUBDOMAIN.DOMAIN.TLD;

	          access_log /var/log/nginx/SUBDOMAIN.access.log;
    	      error_log /var/log/nginx/SUBDOMAIN.error.log;

            location / {
                         try_files $uri $uri/ =404;
            }

            location ~ \.php$ {
                         include snippets/fastcgi-php.conf;
                         fastcgi_pass unix:/run/php/php7.2-fpm.sock;
            }
            
            location ~ /\.ht {
                         deny all;
            }

            location = /favicon.ico {
                         log_not_found off;
                         access_log off;
            }

            location = /robots.txt {
                         allow all;
                         log_not_found off;
                         access_log off;
           }
       
            location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
                         expires max;
                         log_not_found off;
           }
}
#The End" >> /tmp/wordpress.conf

sudo mkdir /etc/smbcredentials
sudo chmod 777 /etc/smbcredentials
sudo echo username=${Storageaccountname} >> /etc/smbcredentials/${Storageaccountname}.cred
sudo echo password=${Storageaccountkey} >> /etc/smbcredentials/${Storageaccountname}.cred
sudo chmod 600 /etc/smbcredentials/${Storageaccountname}.cred
sudo mkdir -p /var/www/html/wordpress/public_html

sudo mount -t cifs //${Storageaccountname}.file.core.windows.net/${Filesharename} /var/www/ -o credentials=/etc/smbcredentials/${Storageaccountname}.cred,dir_mode=0777,file_mode=0777,serverino,nosharesock,actimeo=30

sudo cp /tmp/wordpress.conf /etc/nginx/sites-available/wordpress.conf
cd /etc/nginx/sites-enabled
sudo ln -s ../sites-available/wordpress.conf .
sudo systemctl reload nginx

cd /var/www/html/wordpress/public_html
sudo wget https://wordpress.org/latest.tar.gz
sudo tar -zxvf latest.tar.gz
sudo mv wordpress/* .
sudo rm -rf wordpress
cd /var/www/html/wordpress/public_html
sudo chown -R www-data:www-data *
sudo chmod -R 755 *

sudo cp /tmp/wp-config.php /var/www/html/wordpress/public_html/wp-config.php
sudo rm /etc/nginx/sites-enabled/default
sudo rm /etc/nginx/sites-available/default
sudo systemctl restart nginx