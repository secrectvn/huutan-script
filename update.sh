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
cat << EOF
╔═════════════════════════════════════╗
║╔═╗╔═╗╔╦╗╔═╗╔═╗╔╦╗╔═╗╦═╗╔╗╔╔═╗╔╦╗╔═╗ ║
║║╣ ╔═╝║║║╠═╣╚═╗ ║ ║╣ ╠╦╝║║║║ ║ ║║║╣  ║
║╚═╝╚═╝╩ ╩╩ ╩╚═╝ ╩ ╚═╝╩╚═╝╚╝╚═╝═╩╝╚═╝ ║
║    ╦  ╦╔╦╗╔═╗                       ║
║    ║  ║ ║ ║╣       by SecrectVN     ║
║    ╩═╝╩ ╩ ╚═╝ https://secrectvn.com ║
╚═════════════════════════════════════╝
EOF
}
function install_confirm(){
    # call with a prompt string or use a default
    read -r -p " $red Ban co chac muon update EZLITE script ? [y/N] $end" confirm
    case "$confirm" in
        [yY][eE][sS]|[yY])
            true
            ;;
        *)
            exit
            ;;
    esac
}

function update_ezlite(){
	rm -rf /usr/local/ezlite/
	unlink /usr/bin/ezlite
	git clone https://github.com/secrectvn/huutan-script.git /usr/local/ezlite  ;
	chmod +x /usr/local/ezlite/ezlite.sh ;
  chmod +x /usr/local/ezlite/assets/report.sh ;
	ln -s /usr/local/ezlite/ezlite.sh /usr/bin/ezlite ;
}

echo "$yel Update EZLITE ....... $end"
update_ezlite
