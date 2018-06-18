### DISPLAY ###
display_masternode_menu(){
	tput cup 9 0 && tput ed
	tput cup 9 0
	cat << _main_menu
 1) AUTO MASTERNODE
 2) DEAMON START
 3) MASTERNODE START
 4) MASTERNODE STATUS
 5) MASTERNODE DEBUG
 9) BACK
_main_menu
echo $txReset
}
### ACTION ###

function action_masternode_menu(){
		local choice
	    read -p "$fgGreen $txBold Enter choice [1-6] or [Q]uit : $txReset" choice
			case $choice in
				1)  mn_overview ;;
				2)  install_menu ;;
				3)  masternode_menu ;;
				4)  auto_start ;;
				5)  report ;;
				6) 	license_key ;;
				9) 	return ;;
			 [0qQ])  exit 0;;
		      *)	echo -e $txBold $fgYellow  " The wrong selection, please select again !" $txReset ;;
			 esac
			pause
	}