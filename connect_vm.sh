# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    connect_vm.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: thdelmas <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/01/17 18:19:31 by thdelmas          #+#    #+#              #
#    Updated: 2019/01/17 23:17:51 by thdelmas         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/sh

#VM_IP=10.13.0.158
VM_IP=10.12.1.129
#VM_IP=10.13.42.44
#VM_IP=10.12.42.44
VM_USER="debian"
#VM_USER="thdelmas"

rm ~/.ssh/known_hosts
if [ "22" = "22" ]
then
	while [ `ping -t1 $VM_IP | grep packets | cut -d ',' -f2 | cut -d ' ' -f2` == '0' ]
	do
		echo "Merci de verifier l'ip de la vm"
		read -p "Enter l'ip: " VM_IP
	done
fi
echo "\n---SSH VM CONNECT---\n"

echo "\n---SSH SCRIPT COPY---\n"
scp -v -r . $VM_USER@$VM_IP:~/scripts

#ssh $VM_USER@$VM_IP 'mkdir scripts'
#scp fw.sh $VM_USER@$VM_IP:~/scripts/fw.sh
#scp roger.sh $VM_USER@$VM_IP:~/scripts/roger.sh
#scp etc.network.interfaces $VM_USER@$VM_IP:~/scripts/etc.txt
