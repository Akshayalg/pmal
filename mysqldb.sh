#!/bin/bash

#Required variable declarations
mysqlPassword='12345'
db='wordpress'


sudo apt-get -y update


#Installing mysql server in a Non-Interactive mode
echo "mysql-server-5.6 mysql-server/root_password password $mysqlPassword" | sudo debconf-set-selections 
echo "mysql-server-5.6 mysql-server/root_password_again password $mysqlPassword" | sudo debconf-set-selections 

#Install mysql-server
sudo apt-get -y install mysql-server

#setting password for root user in DB host
sudo mysql -u root -e "set password for 'root'@'192.168.20.20' = PASSWORD('$mysqlPassword')"

#changing Bind address to LAP VM address
sudo sed -i "s/.*bind-address.*/bind-address = 192.168.20.20/" /etc/mysql/my.cnf

#creating database for wordpress
sudo mysql -u root -p${mysqlPassword}  -e "CREATE DATABASE ${db};"

#setting password for remote login from LAP vm
sudo mysql -u root -e "set password for 'santosh'@'192.168.10.10' = PASSWORD('$mysqlPassword')"

#Granting permision to remote login
sudo mysql -u root -p${mysqlPassword} -e "GRANT ALL PRIVILEGES ON ${db}.* TO santosh@'192.168.10.10' IDENTIFIED BY '${mysqlPassword}';"

#Restarting the mysql server
sudo service mysql restart
