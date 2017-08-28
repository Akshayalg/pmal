#!/bin/sh
sudo apt-get -y update
sudo apt-get -y install apache2 php5 php5-mysql

sudo apt-get -y install php5 libapache2-mod-php5 php5-mcrypt

sudo apt-get -y install mysql-client

sudo sed -i '/^[ \t]*<IfModule mod_dir.c>/,/^[ \t]*<\/IfModule>/c\<IfModule mod_dir.c>\n DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm \n <\/IfModule>' /etc/apache2/mods-enabled/dir.conf

sudo apachectl restart

cd /tmp              
sudo curl -O https://wordpress.org/latest.tar.gz

sudo tar xzvf latest.tar.gz

sudo touch /tmp/wordpress/.htaccess
sudo chmod 660 /tmp/wordpress/.htaccess
sudo cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php

sudo cp -a /tmp/wordpress/. /var/www/html

secretkey=$(curl -L https://api.wordpress.org/secret-key/1.1/salt/)
oldkey='put your unique phrase here'
sudo printf '%s\n' "g/$oldkey/d" a "$secretkey" . w | ed -s /var/www/html/wp-config.php

dbuser='username_here'
dbpassword='password_here'
dbname='database_name_here'
dbhost='localhost'
usr='santosh'
pw='12345'
db='wordpress'
hst='192.168.20.20'

sudo sed -i /var/www/html/wp-config.php  -e "s/${dbuser}/${usr}/g" /var/www/html/wp-config.php
sudo sed -i /var/www/html/wp-config.php -e "s/${dbpassword}/${pw}/g" /var/www/html/wp-config.php
sudo sed -i /var/www/html/wp-config.php -e "s/${dbname}/${db}/g" /var/www/html/wp-config.php
sudo sed -i /var/www/html/wp-config.php -e "s/${dbhost}/${hst}/g" /var/www/html/wp-config.php

sudo mv /var/www/html/.htaccess /var/www/html/htaccess.backup

sudo apachectl restart
