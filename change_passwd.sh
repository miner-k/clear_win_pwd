#!/bin/bash
# The os is Ubuntu

menu(){
	clear
	cat <<-EOF
	#############################################
	1.安装ntfs-3g和chntpw
	2.挂载windows的系统盘
	3.全自动安装（系统是默认的，Ubuntu是新购买的）
		[挂载的windows系统盘位置是/dev/xvdb2]
		[步骤4可以省略1-3]
	4.卸载windows的系统盘
	5.退出
	#############################################
	EOF
}


#install ntfs-3g and chntpw

install_untils(){
	apt-get install ntfs-3g chntpw -y
	if [ $? -ne 0 ];then
		echo "can't install install ntfs-3g and chntpw packages"
		exit 3
	fi
}


list_disk(){
	clear
	cat <<-EOF
	##################
	#查看新的磁盘
	##################
	EOF
	lsblk
}




change_pw(){
	
	mount -t ntfs-3g /dev/$1 /mnt/
	
	cp /mnt/Windows/System32/config/SAM{,.bak}
	
	chntpw -u Administrator /mnt/Windows/System32/config/SAM
}



while :
do
	menu
	
	read -p "输入对应的编号：" num
	case $num in
		1) install_untils
		;;
		2) list_disk
		   read -p "Input the name of dev:" dev
		   change_pw $dev
		;;
		3) install_untils
		   change_pw xvdb2
		;;
		4) umount /mnt
		;;
		5) break
		;;
		*)
		echo "输入错误" ;;
	esac 
done
