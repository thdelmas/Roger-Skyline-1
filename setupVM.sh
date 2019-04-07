# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    setupVM.sh                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: thdelmas <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/01/17 18:20:36 by thdelmas          #+#    #+#              #
#    Updated: 2019/01/17 23:18:12 by thdelmas         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/sh

#Var
VM='Debian_64'
VM_NAME="auto_roger"
VMFOLDER=/sgoinfre/goinfre/Perso/thdelmas
# 8 * 1024
VM_SDA_OS_SIZE=8192
VM_RAM=1024
if [ ! -d "$VMFOLDER" ]; then mkdir $VMFOLDER; fi
VIRTUALDSDA_OS=$VMFOLDER/$VM_NAME.vdi
VM_MAC="0050563a2d1c"
VM_MASSSTORAGE_CONTROLLER_NAME="SATA Controller"
VM_MASSSTORAGE_CONTROLLER_DVD_NAME="IDE Controller"
VM_SDB_SIZE=1024
#ISO_PATH=~/Downloads/debian-9.6.0-amd64-netinst.iso
ISO_PATH=/sgoinfre/goinfre/Perso/thdelmas/debi.iso

VBoxManage createvm --name $VM_NAME --ostype $VM --register

VBoxManage modifyvm $VM_NAME --ioapic on
VBoxManage modifyvm $VM_NAME --boot1 disk --boot2 dvd --boot3 none --boot4 none
VBoxManage modifyvm $VM_NAME --memory 1024 --vram 128
VBoxManage modifyvm $VM_NAME --nic1 bridged --bridgeadapter1 en0 --macaddress1 $VM_MAC

#create hdd
VBoxManage createhd --filename "$VIRTUALDSDA_OS" --size $VM_SDA_OS_SIZE --format VDI --variant fixed
VBoxManage storagectl "$VM_NAME" --add sata --controller IntelAHCI --name "$VM_MASSSTORAGE_CONTROLLER_NAME"
VBoxManage storageattach "$VM_NAME" --storagectl "$VM_MASSSTORAGE_CONTROLLER_NAME" --port 0 --device 0 --type hdd --medium $VIRTUALDSDA_OS


#Boot
VBoxManage storagectl "$VM_NAME" --add ide --controller PIIX3 --name "$VM_MASSSTORAGE_CONTROLLER_DVD_NAME"
VBoxManage storageattach "$VM_NAME" --storagectl "$VM_MASSSTORAGE_CONTROLLER_DVD_NAME" --port 0 --device 0 --type dvddrive --medium $ISO_PATH

#launching OS INSTALL
VboxManage startvm $VM_NAME
#restart

read -p "Wanna launch connect_vm.sh ? (0/1): " RET
if [ $RET == '1' ]
then
	echo "Calling next script"
	sh connect_vm.sh
else
	echo "End here"
fi
