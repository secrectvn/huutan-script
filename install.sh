#!/bin/bash
txReset=$(tput sgr0)   # reset attributes
fgRed=$(tput setaf 1) # red
fgGreen=$(tput setaf 2) # green
fgBlue=$(tput setaf 4) # blue
txReset=$(tput sgr0)   # reset attributes
txBold=$(tput bold)   # bold

#######################-B-A-N-N-E-R-#####################
display_banner(){
cat << _banner_
	 ███████╗███████╗███╗   ███╗███╗   ██╗
	 ██╔════╝╚══███╔╝████╗ ████║████╗  ██║ EASY
	 █████╗    ███╔╝ ██╔████╔██║██╔██╗ ██║ CONTROL
	 ██╔══╝   ███╔╝  ██║╚██╔╝██║██║╚██╗██║ MASTERNODE
	 ███████╗███████╗██║ ╚═╝ ██║██║ ╚████║ by SECRECTVN
	 ╚══════╝╚══════╝╚═╝     ╚═╝╚═╝  ╚═══╝ 
_banner_
}
alert_distro(){
	tput clear
	display_banner
	echo $fgRed
	cat << _alert
		ONLY SUPPORT UBUNTU 16.04 !
			STOP INSTALL
_alert
echo $txReset
}
#Function
function install_confirm(){
    # call with a prompt string or use a default
    read -r -p " $fgGreen Would you like to install EZMN ? [y/N] $txReset" confirm
    case "$confirm" in
        [yY][eE][sS]|[yY])
            true
            ;;
        *)
            exit
            ;;
    esac
}

function check_distro(){
	. /etc/os-release
	if [[ "$VERSION_ID" == "16.04" ]]; then			
			install_confirm
		else
		alert_distro && exit 1
	fi
}

function install_swap(){
	if [ $(free | awk '/^Swap:/ {exit !$2}') ] || [ ! -f "/var/mnode_swap.img" ];then
	echo "$fgBlue No SWAP, install now! $txReset"
	#cai dat bo nho swap
	fallocate -l 4G /swapfile
	chmod 600 /swapfile && mkswap /swapfile && swapon /swapfile
	echo "vm.swappiness=10" >> /etc/sysctl.conf
	echo "/swapfile none swap sw 0 0" >> /etc/fstab
	else
		echo "$fgGreen SWAP is installed ! $txReset"
	fi
}

 function install_packages(){
    echo "$fgGreen Install Package ....... $txReset"
    apt-get install -y software-properties-common -y
    add-apt-repository ppa:bitcoin/bitcoin -y ;
    apt update && apt upgrade -y ;
    apt install g++  zip jshon libcurl4-openssl-dev jshon make git apt-utils jp2a virtualenv libcurl3-dev libudev-dev -y   ;
    apt install libdb4.8-dev libdb4.8++-dev libwww-perl htop build-essential libtool automake htop autotools-dev autoconf htop pkg-config libssl-dev -y ;
    apt install libgmp3-dev libevent-dev bsdmainutils libminiupnpc-dev libboost-all-dev libqrencode-dev unzip -y ;
    apt install libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler -y;
}

function install_ezmn(){
	echo "$fgGreen Install EZMN ....... $txReset"
	git clone https://github.com/secrectvn/huutan-script /usr/local/ezmn/  ;
	chmod +x /usr/local/ezmn/ezmn.sh ;
	chmod +x /usr/local/ezmn/assets/report.sh ;
	ln -s /usr/local/ezmn/ezmn.sh /usr/bin/ezmn ;
}

function reboot_confirm(){
    # call with a prompt string or use a default
    read -r -p " $fgRed $txBold  Khoi dong lai VPS  ? [y/N] $txReset" confirm
    case "$confirm" in
        [yY][eE][sS]|[yY])
            reboot
            ;;
        *)
            false
            ;;
    esac
}
# ACTION
	display_banner
	check_distro	
	mkdir -p /root/masternode/
	mkdir -p /root/ezmn/{build,daemon,logs,installed,balance,running,report} ;
	install_log='/root/ezmn/logs/install.log'	
	install_packages 	&> /root/ezmn/logs/install.log
	install_swap	
	install_ezmn 	 &> /root/ezmn/logs/install.log
	echo -e  "0 0 * * * root /usr/local/ezmn/assets/report.sh"  >> /etc/crontab
	reboot_confirm
