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
function install_confirm(){
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
function update_ezmn(){
rm -rf /usr/local/ezmn/
git clone https://github.com/secrectvn/huutan-script.git /usr/local/ezmn  ;
chmod +x /usr/local/ezmn/ezmn.sh ;
chmod +x /usr/local/ezmn/assets/report.sh ;
}
display_banner
#install_confirm
echo "$yel Update EZMN ....... $end"
update_ezmn
