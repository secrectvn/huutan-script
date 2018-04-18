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
display_banner(){
tput bold
echo -n $gre
cat << _banner_
 ███████╗███████╗███╗   ███╗███╗   ██╗
 ██╔════╝╚══███╔╝████╗ ████║████╗  ██║ EASY
 █████╗    ███╔╝ ██╔████╔██║██╔██╗ ██║ CONTROL
 ██╔══╝   ███╔╝  ██║╚██╔╝██║██║╚██╗██║ MASTERNODE
 ███████╗███████╗██║ ╚═╝ ██║██║ ╚████║ by SECRECTVN
 ╚══════╝╚══════╝╚═╝     ╚═╝╚═╝  ╚═══╝
_banner_
echo -n $end
}
alert_distro(){
tput setaf 1
tput bold
cat << _alert
╔═════════════════════════════════════╗
║         ezmn-MASTERNODE           ║
║    chi ho tro Ubuntu 16.04 x64      ║
╚═════════════════════════════════════╝
_alert
tput sgr0
}
#Function
function install_confirm(){
    # call with a prompt string or use a default
    read -r -p " $red Ban co chac muon cai dat ezmn script ? [y/N] $end" confirm
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

function install_ezmn(){
	git clone https://github.com/secrectvn/huutan-script.git /usr/local/ezmn/  ;
	chmod +x /usr/local/ezmn/ezmn.sh ;
	chmod +x /usr/local/ezmn/assets/report.sh ;
	ln -s /usr/local/ezmn/ezmn.sh /usr/bin/ezmn ;
}

# ACTION
	display_banner
	check_distro
	install_confirm
	mkdir -p /root/masternode/
	mkdir -p /root/ezmn/{build,daemon,logs,installed,balance,running,report} ;
	install_log='/root/ezmn/logs/install.log'
	echo "$gre Install Package ....... $end"
	install_packages 	&> /root/ezmn/logs/install.log
	echo "$gre Install SWAP ....... $end"
	install_swap
	echo "$gre Install ezmn ....... $end"
	install_ezmn 	 &> /root/ezmn/logs/install.log
	echo -e  "0 0 * * * root /usr/local/ezmn/assets/report.sh"  >> /etc/crontab
	reboot_confirm
