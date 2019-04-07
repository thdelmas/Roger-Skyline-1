# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    roger.sh                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: thdelmas <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/01/17 18:20:14 by thdelmas          #+#    #+#              #
#    Updated: 2019/01/17 21:54:12 by thdelmas         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/sh


echo "\n--- Moving script folder ---\n"

if [ -d scripts ]
then
	mv scripts /root/scripts
fi

echo "\n--- PRE-ROGER ---\n"
echo "auto_roger" > /etc/hostname
cat /etc/hosts | sed 's/localhost/localhost auto_roger/g' > /etc/hosts2
mv /etc/hosts2 /etc/hosts
echo "\n--- MAKE thdelmas sudo ---\n"
echo "\n--- NEED USER PASSWORD ---\n"

adduser thdelmas
adduser thdelmas sudo

echo "\n--- MAKE IP PARAMS ---\n"
mv /root/scripts/etc.txt /etc/network/interfaces
cat /etc/ssh/sshd_config | sed 's/#Port 22/Port 64242/g' | \
	sed 's/#PermitRootLogin prohibit-password/PermitRootLogin no/g' | \
	sed 's/^#Pubkey/Pubkey/g' \
	> /etc/ssh/sshd_config2
mv /etc/ssh/sshd_config2 /etc/ssh/sshd_config

echo "\n--- APT ---\n"
apt-get update && apt-get upgrade -y
apt-get dist-upgrade -y
apt-get install -y sudo
apt-get install -y fail2ban
apt-get install -y portsentry
apt-get install -y mailutils
apt-get install -y vim

echo "\n--- MAKE FW ---\n"
sh /root/scripts/fw.sh
apt-get install -y iptables-persistent
iptables-save > /etc/iptables/rules.v4
iptables-save > /etc/iptables/rules.v6
mv /root/scripts/crontab /etc/crontab

mv /root/scripts/portsentry.conf /etc/portsentry/portsentry.conf
mv /root/scripts/portsentry.txt /etc/default/portsentry
mv /root/scripts/jail.local /etc/fail2ban/jail.local

rm /etc/fail2ban/filter.d/nginx-http-auth.conf
echo '[Definition]


failregex = ^ \[error\] \d+#\d+: \*\d+ user "\S+":? (password mismatch|was not found in ".*"), client: <HOST>, server: \S+, request: "\S+ \S+ HTTP/\d+\.\d+", host: "\S+"\s*$
            ^ \[error\] \d+#\d+: \*\d+ no user/password was provided for basic authentication, client: <HOST>, server: \S+, request: "\S+ \S+ HTTP/\d+\.\d+", host: "\S+"\s*$

ignoreregex =' > /etc/fail2ban/filter.d/nginx-http-auth.conf

cp /etc/fail2ban/filter.d/apache-badbots.conf /etc/fail2ban/filter.d/nginx-badbots.conf

rm /etc/fail2ban/filter.d/nginx-noscript.conf
echo '[Definition]

failregex = ^<HOST> -.*GET.*(\.asp|\.exe|\.pl|\.cgi|\.scgi)

ignoreregex =' > /etc/fail2ban/filter.d/nginx-noscript.conf

echo '[Definition]

failregex = ^<HOST> -.*GET .*/~.*

ignoreregex =' > /etc/fail2ban/filter.d/nginx-nohome.conf

echo '[Definition]

failregex = ^<HOST> -.*GET http.*

ignoreregex =' > /etc/fail2ban/filter.d/nginx-noproxy.conf

mkdir -p /home/dev/logs/rs1/
touch /home/dev/logs/rs1/error_log
touch /home/dev/logs/rs1/access_log

echo "\n--- RESTART (services) ---\n"
service fail2ban restart
service portsentry restart

echo "\n--- END - ---\n"
read -p "Launch set_nginx.sh ? (0/1) : " RET
if [ $RET = "1" ]
then
	sudo sh /root/scripts/set_nginx.sh
else
echo "\n\n\nReboot...\n"
sleep 5
shutdown -r now
fi
