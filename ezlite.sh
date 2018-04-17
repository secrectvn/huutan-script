#!/bin/bash
#COLORS
black=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)
NC=$(tput sgr0)
# VAR
DIR_EZMN="/usr/local/ezlite"
MN_DATA="/root/masternode"
LS_CRYPTOS="$DIR_EZMN/cryptos"
EZ_CONFIG="$DIR_EZMN/assets/config/"
number_cols=$(((($(tput cols) - 45)) / 5))
mn_address=$(ip route get 1 | awk '{print $NF;exit}');
rd_passwd=$(date +%s | sha256sum | base64 | head -c 32 ;);
wl_passwd=$(date +%s | sha256sum | base64 | head -c 16 ;);

#display
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
main_menu(){
	cat << _main_menu
    1) OVERVIEW MASTERNODE
    2) INSTALL MASTERNODE
    3) START & STOP DEAMON
    4) MASTERNODE START
    5) UNLOCK WALLET
    6) WALLET MANAGEMENT
    7) REPORT
    8) EXIT
_main_menu
}

#input
# input code name
input_code_name(){
	read -p  "${green} Enter the code name ( lowcase ) you want to install : $NC" CODE_NAME
	}
# input walletpassphrase
input_walletpassphrase(){
	read -s -p  "${green} Input Walletpassphrase : $NC" walletpassphrase
	}
# input masternode genkey
input_genkey(){
	read -p  "${green} Input Masternode Genkey : $NC"  mn_genkey ;
	}
# input txhash
input_txhash (){
	read -p  "${green} Input TXHASH (chay lenh masternode outputs): $NC" tx_hash ;
	}
# INPUT TXID
input_txid(){
	echo -e " $green 0) TXID = 0 $NC"
	echo -e " $green 1) TXID = 1 $NC"
	read -p  "$green Choice TXID [0] or [1]: $NC" tx_id
	case $tx_id in
					0) tx_id=0 ;;
					1) tx_id=1 ;;
					*) echo "$red The wrong selection, please select again ! $NC " ;;
	 esac
	}

#action
# check_cryptos support
check_cryptos(){
	if [ -r ${LS_CRYPTOS}/${CODE_NAME}/spec.ezs ];
		then
			source ${LS_CRYPTOS}/${CODE_NAME}/spec.ezs
			mkdir -p ${MN_DATA}/${CRYPTO_NAME}/
		else
			echo "$red This crypto is not yet supported, please contact us for updates ! $NC"
			break ;
		fi
	}
# create_config for cryptos
create_config(){
				source ${LS_CRYPTOS}/$CODE_NAME/spec.ezs
				mkdir -p ${MN_DATA}/${CRYPTO_NAME}/
	# crypto config
			cp -p ${EZ_CONFIG}/config.env  ${MN_DATA}/${CRYPTO_NAME}/${CRYPTO_NAME}.conf
				sed -i "s|RPCCOIN|$CRYPTO_NAME-RPC|g"  ${MN_DATA}/${CRYPTO_NAME}/${CRYPTO_NAME}.conf ;
				sed -i "s|RPCPASS|$rd_passwd|g"  ${MN_DATA}/${CRYPTO_NAME}/${CRYPTO_NAME}.conf ;
				sed -i "s|RPCPORT|$RPC_PORT|g"  ${MN_DATA}/${CRYPTO_NAME}/${CRYPTO_NAME}.conf ;
				sed -i "s|MN_GENKEY|$mn_genkey|g"  ${MN_DATA}/${CRYPTO_NAME}/${CRYPTO_NAME}.conf ;
				sed -i "s|MN_ADDR|$mn_address|g"  ${MN_DATA}/${CRYPTO_NAME}/${CRYPTO_NAME}.conf ;
				sed -i "s|MN_PORT|$MN_PORT|g"  ${MN_DATA}/${CRYPTO_NAME}/${CRYPTO_NAME}.conf ;
				sed -i "s|CODE_NAME|${CODE_NAME}|g"  ${MN_DATA}/${CRYPTO_NAME}/${CRYPTO_NAME}.conf ;
	# masternode config
			cp -p ${EZ_CONFIG}/masternode.env  ${MN_DATA}/${CRYPTO_NAME}/masternode.conf ;
				sed -i "s|MN_ALIAS|$(hostname)|g"  ${MN_DATA}/${CRYPTO_NAME}/masternode.conf ;
				sed -i "s|MN_ADDR|$mn_address|g"  ${MN_DATA}/${CRYPTO_NAME}/masternode.conf ;
				sed -i "s|MN_PORT|$MN_PORT|g"  ${MN_DATA}/${CRYPTO_NAME}/masternode.conf ;
				sed -i "s|MN_GENKEY|$mn_genkey|g"  ${MN_DATA}/${CRYPTO_NAME}/masternode.conf ;
				sed -i "s|TX_HASH|$tx_hash|g"  ${MN_DATA}/${CRYPTO_NAME}/masternode.conf ;
				sed -i "s|TX_ID|$tx_id|g"  ${MN_DATA}/${CRYPTO_NAME}/masternode.conf ;
}
# deamon control
##deamon_start
deamon_start(){
	if [ -z "$(ls -A /root/ezlite/installed/ )" ]; then
	   echo "$red No cryptos are installed ! $NC"
	   break;
	else
		echo -e "$green Please select the cryptos you want to start-deamon or [Q]uit $NC"
		list_ins=$(ls -1 /root/ezlite/installed/ | sed -e 's/\.pid$//')
		select CODE_NAME in $list_ins; do
			condition=$(ls -1 /root/ezlite/installed/ | grep $CODE_NAME | sed -e 's/\.pid$//')
			if [ $CODE_NAME !=$condition ]; then
			source ${LS_CRYPTOS}/${CODE_NAME}/spec.ezs
			${DEAMON_START}
			exit 0 ;
		else [ $CODE_NAME != "q" ]
			exit 0 ;
		fi
		done
	fi
}
##deamon_stop
deamon_stop(){
	if [ -z "$(ls -A /root/ezlite/running/ )" ];
	then
		echo -e "$red Could not find deamon are running ! $NC "
		exit 0;
	else
			echo -e "$green Please select the cryptos you want to stop-deamon or [Q]uit $NC"
			list_ins=$(ls -1 /root/ezlite/running/ | sed -e 's/\.pid$//')
			select CODE_NAME in $list_ins; do
			if [ -n "$CODE_NAME" ]; then
			kill $(cat /root/ezlite/running/${CODE_NAME}.csv)
				exit 0 ;
			else [ $CODE_NAME != "q" ]
				exit 0 ;
			fi
			done
		fi
	}

	deamon_start_and_stop(){
		if [ -z "$(ls -A /root/ezlite/installed/ )" ] ;
			then
				echo "$red No cryptos are installed ! $NC"
		  	    break;
	  	    else
	  	    	echo -e "$green Please select the cryptos you want to start-deamon or [Q]uit $NC"
			    list_ins=$(ls -1 /root/ezlite/installed/ | sed -e 's/\.pid$//')
			    select CODE_NAME in $list_ins; do
			    	if [ $CODE_NAME != "q" ];
					then
						condition=$(ls -1 /root/ezlite/running/ | grep $CODE_NAME | sed -e 's/\.pid$//')
						if [ "$CODE_NAME" == "$condition" ] ;
						then
							source ${LS_CRYPTOS}/${CODE_NAME}/spec.ezs
							echo -e "$yellow${CRYPTO_NAME} deamon has been running !$NC"
							echo -e " $green Y) ${CRYPTO_NAME} deamon stop"
							echo -e " $green N) Quit "
							echo -e " $red If you want to stop ${CRYPTO_NAME} deamon , please choice [Y] or choose [N]o quit !"
							read -r -p "choice  [Y/N] ? $NC" confirm
							case "$confirm" in
						        [yY]) ${DEAMON_MN} stop && break ;;
						        [nN]) break  ;;
								*   ) echo -e " $red Wrong key , please choice again !" && pause  ;;
						    esac
						  else
					  		source ${LS_CRYPTOS}/${CODE_NAME}/spec.ezs
				  			echo -e "$red ${CRYPTO_NAME} deamon start $NC "
						 	${DEAMON_MN};
							break;
						fi
					 fi
		 		done
	  	    fi
		}
# masternode control
## masternode start
mn_start(){
	if [ -z "$(ls -A /root/ezlite/running/ )" ];
	then
		   echo -e "$red Could not find deamon are running ! $NC "
		   break ;
	else
			echo -e "$green Please select the cryptos you want to start-masternode or [Q]uit $NC"
			list_ins=$(ls -1 /root/ezlite/running/ | sed -e 's/\.pid$//')
			select CODE_NAME in $list_ins; do
			if [ -n "$CODE_NAME" ]; then
				input_walletpassphrase
				source ${LS_CRYPTOS}/$CODE_NAME/spec.ezs
				${MN_START} $walletpassphrase
				break ;
			else [ $CODE_NAME != "q" ]
				break ;
			fi
			done
		fi
}
## masternode status
mn_status(){
	if [ -z "$(ls -A /root/ezlite/running/ )" ];
	then
		   echo -e "$red Could not find deamon are running ! $NC "
		   exit 0 ;
	else
			echo -e "$green Please select the cryptos you want to check masterode-status or [Q]uit $NC"
			list_ins=$(ls -1 /root/ezlite/running/ | sed -e 's/\.pid$//')
			select CODE_NAME in $list_ins; do
			if [ -n "$CODE_NAME" ]; then
				source ${LS_CRYPTOS}/$CODE_NAME/spec.ezs
				${MN_STARTUS}
				exit 0 ;
			else [ $CODE_NAME != "q" ]
				exit 0 ;
			fi
			done
		fi
	}
## masternode debug
mn_debug(){

		if [ -z "$(ls -A /root/ezlite/running/ )" ];
		then
			   echo -e "$red Could not find deamon are running ! $NC "
			   exit 0 ;
		else
				echo -e "$green Please select the cryptos you want to check masterode-status or [Q]uit $NC"
				list_ins=$(ls -1 /root/ezlite/running/ | sed -e 's/\.pid$//')
				select CODE_NAME in $list_ins; do
				if [ -n "$CODE_NAME" ]; then
					source ${LS_CRYPTOS}/$CODE_NAME/spec.ezs
					${MN_STARTUS}
					exit 0 ;
				else [ $CODE_NAME != "q" ]
					exit 0 ;
				fi
				done
			fi
		}
# Wallet management
## Staking info
wl_staking(){
	if [ -z "$(ls -A /root/ezlite/running/ )" ];
	then
		   echo -e "$red Could not find deamon are running ! $NC "
		   exit 0 ;
	else
			echo -e "$green Please select the cryptos you want to check wallet-staking or [Q]uit $NC"
			list_ins=$(ls -1 /root/ezlite/running/ | sed -e 's/\.pid$//')
			select CODE_NAME in $list_ins; do
			if [ -n "$CODE_NAME" ]; then
				source ${LS_CRYPTOS}/${CODE_NAME}/spec.ezs
				${WL_STAKTING}
				break
			else [ $CODE_NAME !='q' ]
				exit 0 ;
			fi
			done
		fi
	}
## wallet info
wl_info(){
	if [ -z "$(ls -A /root/ezlite/running/ )" ];
	then
		   echo "$red Khong co deamon nao dang chay ! $NC "
		   break
	else
			PS3="Vui long chon coin ban muon check staking hoac 'q' de thoat : "
			list_ins=$(ls -1 /root/ezlite/running/ | sed -e 's/\.pid$//')
			select CODE_NAME in $list_ins; do
			if [ -n "$CODE_NAME" ]; then
				source ${LS_CRYPTOS}/${CODE_NAME}/spec.ezs
				${WL_INFO}
				break
			else [ $CODE_NAME !='q' ]
				break ;
			fi
			done
		fi
	}
## wallet unlock
wl_unlock(){

	if [ -z "$(ls -A /root/ezlite/running/ )" ];
	then
		   echo -e "$red Could not find deamon are running ! $NC "
		   break
	else
			echo -e "$green Please select the cryptos you want to unlock-wallet or [Q]uit $NC"
			list_ins=$(ls -1 /root/ezlite/running/ | sed -e 's/\.pid$//')
			select CODE_NAME in $list_ins; do
			if [ -n "$CODE_NAME" ]; then
				input_walletpassphrase
				source ${LS_CRYPTOS}/$CODE_NAME/spec.ezs
				${WL_UNLOCK} $walletpassphrase 32000000
				break
			else [ $CODE_NAME != "q" ]
				break ;
			fi
			done
		fi
	}
## wallet balance
wl_balance(){

	if [ -z "$(ls -A /root/ezlite/running/ )" ];
	then
		   echo -e "$red Could not find deamon are running ! $NC "
		   break
	else
			echo -e "$green Please select the cryptos you want to check crypto-balance or [Q]uit $NC"
			list_ins=$(ls -1 /root/ezlite/running/ | sed -e 's/\.pid$//')
			select CODE_NAME in $list_ins; do
			if [ -n "$CODE_NAME" ]; then
				source ${LS_CRYPTOS}/${CODE_NAME}/spec.ezs
				${WL_BALANCE}
				break
			else [ $CODE_NAME != "q" ]
				break ;
			fi
			done
		fi
	}
# pause script
pause(){
		read -p "${yellow} Press [Enter] to continue ... ${NC}" fackEnterKey
	}

 #Install Masternode
# masternode install
mn_install(){
		input_code_name
		check_cryptos
		input_genkey
		input_txhash
		input_txid
		create_config
		echo " $green Compile deamon $CRYPTO_NAME $NC "
		build_git
		touch /root/ezlite/installed/${CODE_NAME}
}
# dashboard
mn_overview(){
	tput clear
	main_banner
	divider===============================
	divider=$divider$divider
	header="%-2s %-15s %-10s %-25s\n"
	format="%-2s %-15s %-10.2f %-25s\n"
	width=55
	printf "$header" " " "CRYPTO NAME" "BALANCE" "STATUS MN"
	printf "%$width.${width}s\n" "$divider"

	DEAMON_RUN=$(ls -1 /root/ezlite/running/ | sed -e 's/\.pid$//')
	for CODE_NAME  in $DEAMON_RUN  ; do
		source /usr/local/ezlite/cryptos/${CODE_NAME}/spec.ezs
		BALANCE=$(${BALANCE_MN})
		STATUS=$(${STATUS_MN} | grep -E 'message|notCapableReason' | tr -d '"' |  awk '{print $3, $4, $5}')
		printf "$format" " " "${COIN_NAME}" "$BALANCE" "$STATUS"

	done
	printf "%$width.${width}s\n" "$divider"
}
rp_balance(){
	tput clear
	main_banner
	divider===============================
	divider=$divider$divider
	header="%-2s %-15s %-10s %-25s\n"
	format="%-2s %-15s %-10.2f %-25s\n"
	width=55
	printf "%$width.${width}s\n" "$divider"
	if [ -z "$(ls -A /root/ezlite/report/ )" ];
	then
		echo "$red Khong tim thay file balance ! $NC "
		break ;
	else
		PS3="Vui long chon coin ban muon check balance hoac 'q' de thoat : "
		list_ins=$(ls -1 /root/ezlite/report/ | sed -e 's/\.csv$//')
		select CODE_NAME in $list_ins; do
		if [ -n "$CODE_NAME" ]; then
                source /usr/local/ezlite/cryptos/${CODE_NAME}/spec.ezs
                LS_BALANCE=$(cat /root/ezlite/report/${CODE_NAME}.csv | awk -F "\"* ; \"*" '{print $1, $2}')
                printf "$header" "${COIN_NAME}"
                printf "%$width.${width}s\n" "$divider"
                printf "$format" "$LS_BALANCE"
				printf ""
		else [ $CODE_NAME !='q' ]
			break ;
		fi
		done
		printf "%$width.${width}s\n" "$divider"
	fi
}
# Action Main Menu
function action_main_menu(){
	    local choice
	    read -p "$green Enter choice [1-8] or [Q]uit : $NC" choice
			case $choice in
		      1)  mn_overview ;;
		      2)  mn_install ;;
					3)  deamon_start_and_stop ;;
		      4)  mn_start ;;
		      5)  wl_unlock ;;
		      6)  echo -e "WALLET MANAGEMENT  - wait update " ;;
					7)  rp_balance ;;
					[0qQ])  exit 0;;
		      *)	echo "${red} The wrong selection, please select again ! $NC " ;;
			 esac
			pause
	}
# Trap CTRL+C, CTRL+Z and quit singles
	#trap '' SIGINT SIGQUIT SIGTSTP
#LOGIC
	while true
		do
			tput clear
			tput bold
			main_banner | PREFIX=$(tput cr; tput cuf $number_cols) awk ' {print ENVIRON["PREFIX"] $0}'
			main_menu | PREFIX=$(tput cr; tput cuf $number_cols) awk ' {print ENVIRON["PREFIX"] $0}'
			tput sgr0
			action_main_menu
		done
