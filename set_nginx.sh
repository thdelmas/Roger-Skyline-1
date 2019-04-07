# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    set_nginx.sh                                       :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: thdelmas <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/01/17 18:20:25 by thdelmas          #+#    #+#              #
#    Updated: 2019/01/17 21:14:39 by thdelmas         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/sh
#Run as root

apt-get purge -y apache2
apt-get purge -y nginx nginx-common nginx-fully
apt-get update && \
	apt-get install -y nginx
read -p "Install SQL ? (0/1)" RET
if [ "$RET" = "1" ]
then
	apt-get install -y mysql-server
	mysql_secure_installation
fi
read -p "Install PHP ? (0/1)" RET2
if [ "$RET2" = "1" ]
then
	apt-get install -y php
	apt-get install -y php-fpm
	apt-get purge -y apache2
	cat /etc/php/7.0/fpm/php.ini | \
		sed 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' \
		> /etc/php/7.0/fpm/php.ini2
	mv /etc/php/7.0/fpm/php.ini2 /etc/php/7.0/fpm/php.ini
	service php7.0-fpm restart
fi
if [ "$RET2" = "1" ] && [ "$RET" = "1" ]
then
	apt-get install -y php-mysql
	apt-get purge -y apache2
	apt-get install -y nginx
fi
#cat /root/scripts/nginx.conf > /etc/nginx/nginx.conf

#cat /etc/nginx/sites-available/default | \
	#	sed 's/index index.html/index index.php index.html/g' > tmp.txt
#mv tmp.txt /etc/nginx/sites-available/default


cat /root/scripts/default.txt > tmp.txt
mv tmp.txt /etc/nginx/conf.d/monsite.test.conf
rm /etc/nginx/sites-available/default
rm /etc/nginx/sites-enabled/default

mkdir -p /var/www/monsite.test/logs
touch /var/www/monsite.test/logs/error_log
touch /var/www/monsite.test/logs/access_log


cat /root/scripts/index.php > tmp.txt
mv tmp.txt /var/www/monsite.test/index.php

echo "\n--- END - ---\n"
read -p "Launch ssl.sh ? (0/1) : " RET
if [ $RET = "1" ]
then
	sudo sh /root/scripts/ssl.sh
else
	echo "\n\n\nReboot...\n"
	service nginx reload
	shutdown -r now
fi
