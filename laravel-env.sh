#!/usr/bin/env bash

projname="hodoken"

apt update -y
apt upgrade -y 

fallocate -l 8g /mnt/swapfile
chmod 600 /mnt/swapfile
mkswap /mnt/swapfile
swapon /mnt/swapfile
echo -e "/mnt/swapfile\tswap\tswap\tdefaults\t0\t0" >> /etc/fstab
mount -a

apt-get install software-properties-common -y
add-apt-repository ppa:ondrej/php -y && apt update -y

apt install supervisor unzip git mariadb-server mariadb-client nginx redis-server -y

version='7.4'
apt install php${version}-fpm php${version}-gmp php${version}-gd php${version}-mysql php${version}-redis php-redis php${version}-zip php${version}-curl php${version}-bcmath php${version}-xml php${version}-mbstring php-pear php${version}-dev -y

dbname=$projname
mysql -e "create database ${dbname} charset=utf8mb4;"
mysql -e "grant all privileges on ${dbname}.* to ${dbname}@localhost identified by 'X0affj8XLQc3Q';"

## 2022-10-09
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/bin/composer

composer install 

mkdir storage/logs
chown -R www-data:www-data .

./artisan key:generate