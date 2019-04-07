# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    update_script.sh                                   :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: thdelmas <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/01/17 18:20:44 by thdelmas          #+#    #+#              #
#    Updated: 2019/01/17 18:20:46 by thdelmas         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/sh

echo "\n--- APT ---\n"
apt-get update && apt-get upgrade -y >> /var/log/update_script.log
apt-get dist-upgrade -y >> /var/log/update_script.log
