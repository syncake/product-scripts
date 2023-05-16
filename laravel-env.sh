#!/usr/bin/env bash

projname="hadoken"
projpath="/opt/api"

apt update -y
apt upgrade -y 

## ubuntu
# apt-get install software-properties-common -y
# add-apt-repository ppa:ondrej/php -y && apt update -y

apt install supervisor unzip git mariadb-server mariadb-client nginx redis-server -y

version='7.4'
apt install php${version}-fpm php${version}-gmp php${version}-gd php${version}-mysql php${version}-redis php-redis php${version}-zip php${version}-curl php${version}-bcmath php${version}-xml php${version}-mbstring php-pear php${version}-dev -y

## php command may be required to re-config by alternatives
# update-alternatives --config php
## and then select the target version

## composer 2022-10-09
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/bin/composer

########################################################################

## sys optimized
fallocate -l 8g /mnt/swapfile
chmod 600 /mnt/swapfile
mkswap /mnt/swapfile
swapon /mnt/swapfile
echo -e "/mnt/swapfile\tswap\tswap\tdefaults\t0\t0" >> /etc/fstab
mount -a
### ulimit
echo -ne "* soft nofile 204800\n* hard nofile 204800\n* soft nproc 204800\n* hard nproc 204800\n" >> /etc/security/limits.conf
echo -ne "\n\nulimit -n 204800" >> /etc/profile
### nginx
sed -i "s/worker_connections 768;/use epoll;\n\tworker_connections 204800;/" /etc/nginx/nginx.conf
service nginx reload

########################################################################
mysql -e "create database ${projname} charset=utf8mb4;"
mysql -e "grant all privileges on ${projname}.* to ${projname}@localhost identified by 'X0affj8XLQc3Q';"

cd $projpath
composer install 

mkdir -p $projpath/storage/logs
chown -R www-data:www-data $projpath

php $projpath/artisan key:generate

# crontab setup
crontab_file="/var/spool/cron/crontabs/root"
echo "0 * * * * /usr/bin/chown -R www-data:www-data ${projpath}" >> $crontab_file
echo "0 * * * * /usr/bin/supervisorctl start all" >> $crontab_file
chown root:crontab $crontab_file
chmod 600 $crontab_file

## optional
crontab_file="/var/spool/cron/crontabs/www-data"
echo "* * * * * /usr/bin/php ${projpath}/artisan schedule:run" >> $crontab_file
chown www-data:crontab $crontab_file
chmod 600 $crontab_file