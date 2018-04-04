#!/bin/bash
bla=$(tput setaf 0)
red=$(tput setaf 1)
gre=$(tput setaf 2)
yel=$(tput setaf 3)
blu=$(tput setaf 4)
mag=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)
end=$(tput sgr0)
error=$(tput cup 22 12)
bold=$(tput bold)
#######################-B-A-N-N-E-R-#####################
text0='╔═════════════════════════════════════╗'
text1='║╔═╗╔═╗╔╦╗╔═╗╔═╗╔╦╗╔═╗╦═╗╔╗╔╔═╗╔╦╗╔═╗ ║'
text2='║║╣ ╔═╝║║║╠═╣╚═╗ ║ ║╣ ╠╦╝║║║║ ║ ║║║╣  ║'
text3='║╚═╝╚═╝╩ ╩╩ ╩╚═╝ ╩ ╚═╝╩╚═╝╚╝╚═╝═╩╝╚═╝ ║'
text4='║    ╦  ╦╔╦╗╔═╗                       ║'
text5='║    ║  ║ ║ ║╣       by SecrectVN     ║'
text6='║    ╩═╝╩ ╩ ╚═╝ https://secrectvn.com ║'
text7='╚═════════════════════════════════════╝'
alert1='╔═════════════════════════════════════╗'
alert2='║         EZLITE-MASTERNODE           ║'
alert3='║    chi ho tro Ubuntu 16.04 x64      ║'
alert4='╚═════════════════════════════════════╝'
#######################-B-A-N-N-E-R-#####################
alert_distro(){	
			tput cup 10 11
			echo "$red $alert1 $end"
			tput cup 11 11
			echo "$red $alert2 $end"
			tput cup 12 11
			echo "$red $alert3 $end"
			tput cup 13 11
			echo "$red $alert4 $end"
			exit 1
}
#Function
function display_banner(){
	tput clear
	tput setaf 2
	tput cup 1 12
	echo "$text0"
	tput cup 2 12 
	echo "$text1"
	tput cup 3 12
	echo "$text2"
	tput cup 4 12 
	echo "$text3"
	tput cup 5 12 
	echo "$text4"
	tput cup 6 12 
	echo "$text5"
	tput cup 7 12 
	echo "$text6"
	tput cup 8 12 
	echo "$text7"
	tput sgr0
}

function install_confirm(){
    # call with a prompt string or use a default
    read -r -p " $red Ban co chac muon cai dat EZLITE script ? [y/N] $end" confirm
    case "$confirm" in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            exit 
            ;;
    esac
}

function reboot_confirm(){
    # call with a prompt string or use a default
    read -r -p " $red Khoi dong lai VPS  ? [y/N]} $end" confirm
    case "$confirm" in
        [yY][eE][sS]|[yY]) 
            reboot
            ;;
        *)
            false
            ;;
    esac
}

function check_distro(){
	# currently only for Ubuntu 16.04
	if [[ -r /etc/os-release ]]; then
		. /etc/os-release 
		if [[ "${VERSION_ID}" != "16.04" ]]; then
			echo -e " ${PRETTY_NAME}"
			alert_distro
		fi
	else
		# no, thats not ok!
		alert_distro
		exit 1
	fi
} 

function install_swap(){ 
#check bo nho swap
if [ $(free | awk '/^Swap:/ {exit !$2}') ] || [ ! -f "/var/mnode_swap.img" ];then
	echo "$blu Swap chua co , cai dat Swap ngay ! $end" 
	#cai dat bo nho swap
	fallocate -l 4G /swapfile
	chmod 600 /swapfile && mkswap /swapfile && swapon /swapfile 
	echo "vm.swappiness=10" >> /etc/sysctl.conf  
	echo "/swapfile none swap sw 0 0" >> /etc/fstab  
	else
		echo "$gre Bo nho swap da duoc cai dat ! $end"	
	fi
} 

function install_packages(){	
	apt-get install -y software-properties-common -y
	add-apt-repository ppa:bitcoin/bitcoin -y ;
	add-apt-repository ppa:tsl0922/ttyd-dev -y ;
	apt update && apt upgrade -y ;
	apt install g++ ttyd zip libcurl4-openssl-dev make git apt-utils jp2a virtualenv libcurl3-dev libudev-dev -y   ;
	apt install libdb4.8-dev libdb4.8++-dev libwww-perl htop build-essential libtool automake htop autotools-dev autoconf htop pkg-config libssl-dev -y ;
	apt install libgmp3-dev libevent-dev bsdmainutils libminiupnpc-dev libboost-all-dev libqrencode-dev unzip -y ;
	apt install libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler -y;
} 

function install_ezlite(){	
	git clone https://github.com/secrectvn/huutan-script.git /usr/local/ezlite  ;
	chmod +x /usr/local/ezlite/ezlite.sh ;
	ln -s /usr/local/ezlite/ezlite.sh /usr/bin/ezlite ;
}

# ACTION
	display_banner
	check_distro 
	install_confirm 
	mkdir -p /root/masternode/
	mkdir -p /root/ezlite/{build,daemon,logs,installed,balance,running,report} ;
	install_log='/root/ezlite/logs/install.log'
	echo "$gre Install Package ....... $end"
	install_packages 	&> /root/ezlite/logs/install.log
	echo "$gre Install SWAP ....... $end"
	install_swap
	echo "$gre Install EZLITE ....... $end"
	install_ezlite 	 &> /root/ezlite/logs/install.log
	chmod +x /usr/local/ezlite/assets/report.sh
	echo -e  "0 0 * * * root /usr/local/ezlite/assets/report.sh"  >> /etc/crontab
	reboot_confirm