#################### BANNER ##########################
main_banner(){
	echo -e ""
	cat << _banner_
   ███████╗███████╗███╗   ███╗███╗   ██╗
   ██╔════╝╚══███╔╝████╗ ████║████╗  ██║ EASY
   █████╗    ███╔╝ ██╔████╔██║██╔██╗ ██║ CONTROL
   ██╔══╝   ███╔╝  ██║╚██╔╝██║██║╚██╗██║ MASTERNODE
   ███████╗███████╗██║ ╚═╝ ██║██║ ╚████║ by SECRECTVN
   ╚══════╝╚══════╝╚═╝     ╚═╝╚═╝  ╚═══╝
_banner_
}
###################### MAIN MENU #########################
### DISPLAY ###
main_menu(){
	cat << _main_menu
	1) OVERVIEW MASTERNODE
	2) INSTALL MENU
	3) WALLET MENU
	4) AUTO START 
	5) AUTO INSTALL
	6) REPORT 
	9) EXIT
_main_menu
}
### ACTION ###

function action_main_menu(){
	    local choice
	    read -p "$fgBlue Enter choice [1-8] or [Q]uit : $txReset" choice
			case $choice in
				1)  mn_overview ;;
				2)  install_menu ;;
				3)  daemon_start ;;
				4)  mn_start ;;
				5)  wl_unlock ;;
				6)  echo -e "WALLET MANAGEMENT  - wait update " ;;
				7)  rp_balance ;;
				8)  daemon_stop ;;
			 [0qQ])  exit 0;;
		      *)	echo "${red} The wrong selection, please select again ! $txReset " ;;
			 esac
			pause
	}
############################################################
mn_overview(){
	tput clear
	main_banner
	divider==============================================================
	divider=$divider$divider
	header="%-2s %-20s %-10s %-30s %-25s\n"
	format="%-2s %-20s %-10.2f %-30s %-25s\n"
	width=100
	printf "$header" " " "CRYPTO NAME" "BALANCE" "VERSION" "STATUS MN"
	printf "%$width.${width}s\n" "$divider"

	DAEMON_RUN=$(ls -1 /root/ezmn/running/ | sed -e 's/\.pid$//')
	for CODE_NAME  in $DAEMON_RUN  ; do
		source /usr/local/ezmn/cryptos/${CODE_NAME}/spec.ezs
		source /usr/local/ezmn/cmd/CMD-${ID}.ezs
		if ["${ID}" == "1"]; then 
			source /usr/local/ezmn/cmd

	  	BALANCE=$(${WL_BALANCE})
		if [ "$OV_STATUS" == '""' ] || [ "$OV_STATUS" == '"Masternode successfully started"' ]; then 
		STATUS="successfully"
		else   
		STATUS="$OV_STATUS"
		fi
		printf "$format" " " "${CRYPTO_NAME}" "$BALANCE" "${OV_VERSION}" "$STATUS" 
		printf "%$width.${width}s\n" "$divider$divider"				
		
	done

}