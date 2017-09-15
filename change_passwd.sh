#!/bin/bash
# The os is Ubuntu
# Author : miner_k
# version : 0.2

check_sys(){
	os=$(lsb_release -a | grep "Distributor ID" | awk -F' ' '{print $NF}')
	if [ $os != 'Ubuntu' ];then
		echo "这个操作系统不是Ubuntu，请使用Ubuntu操作系统"
		exit 2
	fi
}



#install ntfs-3g and chntpw

install_untils(){
	apt-get install ntfs-3g chntpw -y
	if [ $? -ne 0 ];then
		echo "can't install install ntfs-3g and chntpw packages"
		exit 3
	fi
}


change_pw(){
	
	mount -t ntfs-3g /dev/$1 /mnt/
	
	cp /mnt/Windows/System32/config/SAM{,.bak}
	
	chntpw -u Administrator /mnt/Windows/System32/config/SAM
}



remove_pw(){	
install_untils
change_pw xvdb2 <<EOF
1
q
y
EOF

umount /mnt
}


check_sys

while :
do
	diskNum=$(lsblk | grep disk | wc -l)
	if [ $diskNum -eq 2 ];then
		lsblk -f /dev/xvdb | grep ntfs
		if [ $? -eq 0 ];then
			remove_pw
			init 0
		fi
	fi

done
