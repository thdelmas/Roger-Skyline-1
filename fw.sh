# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    fw.sh                                              :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: thdelmas <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/01/17 18:19:47 by thdelmas          #+#    #+#              #
#    Updated: 2019/01/17 18:19:52 by thdelmas         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/sh


iptables -F


iptables -P OUTPUT DROP
iptables -P INPUT DROP
iptables -P FORWARD DROP


iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT


# Accept loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT



# Allow the following ports through from outside 

# SSH = 64242

# SMTP = 25
# DNS = 53
# HTTP = 80
# HTTPS = 443

################# Below are for INTPUT iptables rules #############################################

# chill bill 
iptables -A INPUT -p tcp --dport 64242 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp --dport 20 -j ACCEPT
iptables -A INPUT -p tcp --dport 21 -j ACCEPT
iptables -A INPUT -p tcp --dport 25 -j ACCEPT
iptables -A INPUT -p tcp --dport 53 -j ACCEPT
iptables -A INPUT -p udp --dport 53 -j ACCEPT

iptables -A INPUT -p tcp --dport 3306 -j ACCEPT
iptables -A INPUT -p tcp --dport 9098 -j ACCEPT
iptables -A INPUT -p tcp --dport 9080 -j ACCEPT

################# Below are for OUTPUT iptables rules #############################################

## Allow loopback OUTPUT 
iptables -A OUTPUT -o lo -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow pings
iptables -A OUTPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT

## Reject Forwarding  traffic
iptables -A FORWARD -j REJECT

iptables -A OUTPUT -p tcp --dport 64242 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 20 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 21 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 25 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT

iptables -A OUTPUT -p tcp --dport 3306 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 9098 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 9080 -j ACCEPT
