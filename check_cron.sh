# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    check_cron.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: thdelmas <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/01/17 18:19:25 by thdelmas          #+#    #+#              #
#    Updated: 2019/01/17 18:19:26 by thdelmas         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

if [ -e /var/log/crontab_checksum ]
then
	md5sum /etc/crontab > /tmp/crontab_check
	diff -q /tmp/crontab_check /var/log/crontab_checksum
	if [ $? -ne 0 ]
	then
		echo 'Le fichier /etc/crontab a ete modifie' | mail -s crontab root
		md5sum /etc/crontab >> /var/log/crontab_checksum
	fi
else
	md5sum /etc/crontab > /var/log/crontab_checksum
fi
