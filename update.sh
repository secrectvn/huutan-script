#!/bin/bash
bla=$(tput setaf 0)
red=$(tput setaf 1)
gre=$(tput setaf 2)
yel=$(tput setaf 3)
blu=$(tput setaf 4)
end=$(tput sgr0)
#######################-B-A-N-N-E-R-#####################
display_banner(){
 echo -n $gre
 tput bold
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
 function install_packages(){
    echo "$fgGreen Install Package ....... $txReset"
    apt-get install -y software-properties-common -y
    add-apt-repository ppa:bitcoin/bitcoin -y ;
    add-apt-repository ppa:tsl0922/ttyd-dev -y ;
    apt update && apt upgrade -y ;
    apt install g++ ttyd zip jshon libcurl4-openssl-dev jshon make git apt-utils jp2a virtualenv libcurl3-dev libudev-dev -y   ;
    apt install libdb4.8-dev libdb4.8++-dev libwww-perl htop build-essential libtool automake htop autotools-dev autoconf htop pkg-config libssl-dev -y ;
    apt install libgmp3-dev libevent-dev bsdmainutils libminiupnpc-dev libboost-all-dev libqrencode-dev unzip -y ;
    apt install libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler -y;
}
install_confirm(){
    # call with a prompt string or use a default
    read -r -p " $red Ban co chac muon update EZMN script ? [y/N] $end" confirm
    case "$confirm" in
        [yY][eE][sS]|[yY])
            true
            ;;
        *)
            exit
            ;;
    esac
}
update_ezmn(){
rm -rf /usr/local/ezmn
git clone https://github.com/secrectvn/huutan-script.git /usr/local/ezmn  ;
chmod +x /usr/local/ezmn/ezmn.sh ;
chmod +x /usr/local/ezmn/assets/report.sh

}
display_banner
#install_confirm
echo "$yel Update EZMN ....... $end"
install_packages
update_ezmn

