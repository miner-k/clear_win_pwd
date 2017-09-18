#!/bin/bash
# The os is Ubuntu
# Author : miner_k
# version : 0.3


volume=""

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



#判断哪个分区是系统分区
getDisk(){
num="$(lsblk | grep xvdb | wc -l)"
i=1
while [ $i -lt $num ]
do
        mount /dev/xvdb$i /mnt/
        i=$[$i+1]
        if [ -f "/mnt/Windows/System32/config/SAM" ];then
                volume="xvdb$i"
        else
                umount /mnt
                continue

        fi
done
umount /mnt
}


remove_pw(){	
install_untils
change_pw $volume <<EOF
1
q
y
EOF

umount /mnt
}


check_sys

getDisk

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
