#!/bin/bash
# VAR
DIR_EZMN="/usr/local/ezmn"
MN_DATA="/root/masternode"
LS_CRYPTOS="$DIR_EZMN/cryptos"
EZ_CONFIG="$DIR_EZMN/assets/config/"
source $DIR_EZMN/assets/colors.ezs
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


# Fuction
# input code name
input_code_name(){
	read -p  "$fgGreen Enter the code name ( lowcase ) you want to install : $txReset" CODE_NAME
	}
# input walletpassphrase
input_walletpassphrase(){
	read -s -p  "$fgGreen Input Walletpassphrase : $txReset" walletpassphrase
	}
# input masternode genkey
input_genkey(){
	read -p  "$fgGreen Input Masternode Genkey : $txReset"  mn_genkey ;
	}
# input txhash
input_txhash (){
	read -p  "$fgGreen Input TXHASH : $txReset" tx_hash ;
	}
# INPUT TXID
input_txid(){
	echo -e " $fgBlue 0) TXID = 0 $txReset"
	echo -e " $fgBlue 1) TXID = 1 $txReset"
	read -p  "$fgBlue Choice TXID [0] or [1]: $txReset" tx_id
	case $tx_id in
					0) tx_id=0 ;;
					1) tx_id=1 ;;
					*) echo "$red The wrong selection, please select again ! $txReset " ;;
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
			echo "$red This crypto is not yet supported, please contact us for updates ! $txReset"
			break ;
		fi
	}
# create_config for cryptos
create_config(){
			input_genkey
			input_txhash
			input_txid		
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

# daemon control
##DAEMON_START
daemon_start(){
	if [ -z "$(ls -A /root/ezmn/installed/ )" ]; then
	   echo "$red No cryptos are installed ! $txReset"
	   break;
	else
		echo -e "$fgBlue Please select the cryptos you want to START-DAEMON or [Q]uit $txReset"
		list_ins=$(ls -1 /root/ezmn/installed/ )
		select CODE_NAME in $list_ins; do
			if [ -n "$CODE_NAME" ]; then
			source ${LS_CRYPTOS}/${CODE_NAME}/spec.ezs
			${DAEMON_START}			
		else [ "$CODE_NAME" == "q" ]
			break ;
		fi
		done
	fi
}
##daemon_stop
daemon_stop(){
	if [ -z "$(ls -A /root/ezmn/running/ )" ];
	then
		echo -e "$red Could not find daemon are running ! $txReset "
		break;
	else
			echo -e "$fgBlue Please select the cryptos you want to ST-DAEMON or [Q]uit $txReset"
			list_ins=$(ls -1 /root/ezmn/running/ | sed -e 's/\.pid$//')
			select CODE_NAME in $list_ins; do
			if [ -n "$CODE_NAME" ]; then
			kill (cat /root/ezmn/running/${CODE_NAME}.pid )
			else [ "$CODE_NAME" == "q" ]
				break ;
			fi
			done
		fi
	}
# masternode control
## masternode start
mn_start(){
	if [ -z "$(ls -A /root/ezmn/running/ )" ];
	then
		   echo -e "$red Could not find daemon are running ! $txReset "
		   break ;
	else
			echo -e "$fgBlue Please select the cryptos you want to start-masternode or [Q]uit $txReset"
			list_ins=$(ls -1 /root/ezmn/running/ | sed -e 's/\.pid$//')
			select CODE_NAME in $list_ins; do
			if [ -n "$CODE_NAME" ]; then
				input_walletpassphrase
				source ${LS_CRYPTOS}/$CODE_NAME/spec.ezs
				${MN_START} $walletpassphrase
				break ;
			else [ "$CODE_NAME" == "q" ]
				break ;
			fi
			done
		fi
}
## masternode status
mn_status(){
	if [ -z "$(ls -A /root/ezmn/running/ )" ];
	then
		   echo -e "$red Could not find daemon are running ! $txReset "
		   break ;
	else
			echo -e "$fgBlue Please select the cryptos you want to check masterode-status or [Q]uit $txReset"
			list_ins=$(ls -1 /root/ezmn/running/ | sed -e 's/\.pid$//')
			select CODE_NAME in $list_ins; do
			if [ -n "$CODE_NAME" ]; then
				source ${LS_CRYPTOS}/$CODE_NAME/spec.ezs
				${MN_STATUS}
				break ;
			else [ "$CODE_NAME" == "q" ]
				break ;
			fi
			done
		fi
	}
## masternode debug
mn_debug(){
		if [ -z "$(ls -A /root/ezmn/running/ )" ];
		then			   echo -e "$red Could not find daemon are running ! $txReset "
			   break ;
		else
				echo -e "$fgBlue Please select the cryptos you want to check masterode-status or [Q]uit $txReset"
				list_ins=$(ls -1 /root/ezmn/running/ | sed -e 's/\.pid$//')
				select CODE_NAME in $list_ins; do
				if [ -n "$CODE_NAME" ]; then
					source ${LS_CRYPTOS}/$CODE_NAME/spec.ezs
					${MN_STATUS}
					break ;
				else [ "$CODE_NAME" == "q" ]
					break ;
				fi
				done
			fi
		}
# Wallet management
## Staking info
wl_staking(){
	if [ -z "$(ls -A /root/ezmn/running/ )" ];
	then
		   echo -e "$red Could not find daemon are running ! $txReset "
		   break ;
	else
			echo -e "$fgBlue Please select the cryptos you want to check wallet-staking or [Q]uit $txReset"
			list_ins=$(ls -1 /root/ezmn/running/ | sed -e 's/\.pid$//')
			select CODE_NAME in $list_ins; do
			if [ -n "$CODE_NAME" ]; then
				source ${LS_CRYPTOS}/${CODE_NAME}/spec.ezs
				${WL_STAKTING}
				break
			else [ $CODE_NAME !='q' ]
				break ;
			fi
			done
		fi
	}
## wallet info
wl_info(){
	if [ -z "$(ls -A /root/ezmn/running/ )" ];
	then
		   echo "$red Khong co daemon nao dang chay ! $txReset "
		   break
	else
			PS3="Vui long chon coin ban muon check staking hoac 'q' de thoat : "
			list_ins=$(ls -1 /root/ezmn/running/ | sed -e 's/\.pid$//')
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

	if [ -z "$(ls -A /root/ezmn/running/ )" ];
	then
		   echo -e "$red Could not find daemon are running ! $txReset "
		   break
	else
			echo -e "$fgBlue Please select the cryptos you want to unlock-wallet or [Q]uit $txReset"
			list_ins=$(ls -1 /root/ezmn/running/ | sed -e 's/\.pid$//')
			select CODE_NAME in $list_ins; do
			if [ -n "$CODE_NAME" ]; then
				input_walletpassphrase
				source ${LS_CRYPTOS}/$CODE_NAME/spec.ezs
				${WL_UNLOCK} $walletpassphrase 32000000
				break
			else [ "$CODE_NAME" == "q" ]
				break ;
			fi
			done
		fi
	}
## wallet balance
wl_balance(){

	if [ -z "$(ls -A /root/ezmn/running/ )" ];
	then
		   echo -e "$red Could not find daemon are running ! $txReset "
		   break
	else
			echo -e "$fgBlue Please select the cryptos you want to check crypto-balance or [Q]uit $txReset"
			list_ins=$(ls -1 /root/ezmn/running/ | sed -e 's/\.pid$//')
			select CODE_NAME in $list_ins; do
			if [ -n "$CODE_NAME" ]; then
				source ${LS_CRYPTOS}/${CODE_NAME}/spec.ezs
				${WL_BALANCE}
				break
			else [ "$CODE_NAME" == "q" ]
				break ;
			fi
			done
		fi
	}
# pause script
pause(){
		echo -e " "
		read -p "${yellow} Press [Enter] to continue ... ${NC}" fackEnterKey
	}

 #Install Masternode
# masternode install
mn_install(){
		input_code_name
		check_cryptos
		echo " $fgBlue Compile daemon $CRYPTO_NAME $txReset "
		build_daemon
		touch /root/ezmn/installed/${CODE_NAME}
}
wl_compile(){
	input_code_name
	source ${LS_CRYPTOS}/${CODE_NAME}/spec.ezs
	build_daemon	
}

# dashboard
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
rp_balance(){
	tput clear
	main_banner
	divider===============================
	divider=$divider$divider
	width=55
	header="%-2s %-15s %-10s %-25s\n"
	format="%-2s %-15s %-10.2f %-25s\n"
	printf "%$width.${width}s\n" "$divider"
	if [ -z "$(ls -A /root/ezmn/report/ )" ];
	then
		echo "$red Khong tim thay file balance ! $txReset "
		break ;
	else
		PS3="Vui long chon coin ban muon check balance hoac 'q' de thoat : "
		list_ins=$(ls -1 /root/ezmn/report/ | sed -e 's/\.csv$//')
		select CODE_NAME in $list_ins; do
		if [ -n "$CODE_NAME" ]; then
                source /usr/local/ezmn/cryptos/${CODE_NAME}/spec.ezs
                LS_BALANCE=$(cat /root/ezmn/report/${CODE_NAME}.csv | awk -F "\"* ; \"*" '{print $1, $2}')
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
	    read -p "$fgBlue Enter choice [1-8] or [Q]uit : $txReset" choice
			case $choice in
				1)  mn_overview ;;
				2)  mn_install ;;
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
