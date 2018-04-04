#!/bin/bash
#
# SOURCE
source /usr/local/ezlite/lib/banner.ezs
mn_address=$(ip route get 1 | awk '{print $NF;exit}');
rd_passwd=$(date +%s | sha256sum | base64 | head -c 32 ;);
wl_passwd=$(date +%s | sha256sum | base64 | head -c 16 ;);
# ACTION
#
# INPUT CODE NAME
input_crypto_name(){
read -p  " $gre Nhap ten CODENAME ( viet thuong ) cua coin do :  $end " CODE_NAME
}
# INPUT WALLETPASS
input_walletpassphrase(){
read -s -p  " $gre Nhap Walletpassphrase  :  $end " walletpassphrase
}
# INPUT GENKEY
input_genkey(){
read -p  "$gre Nhap Masternode Genkey ( chay lenh masternode genkey): $end"  mn_genkey ; 
}
# INPUT TXHASH
input_txhash (){
read -p  "$gre Nhap TXHASH (chay lenh masternode outputs): $end" tx_hash ;
}
# INPUT TXID
input_txid(){
	echo -e  "$gre Choice TXID 0 or 1: $end"
		select tx_id in 0 1
			do
			case $tx_id in 
			0|1) break ;;
			*) echo "$red Chon sai TXID. Vui long chon lai $end ";;
			esac
			done
}
# CHECK CRYPTOS SUPORTS
check_cryptos(){		
if [ -r /usr/local/ezlite/cryptos/${CODE_NAME}/spec.ezs ];
	then		
		mkdir -p /root/masternode/${CRYPTO_NAME}/
	else
		echo "$red MASTERNODE chua duoc ho tro. Vui long cho doi ban update tiep theo ! $end"
		exit 0 ;
	fi
}
# CREATE CONFIG
create_config(){
				source /usr/local/ezlite/cryptos/$CODE_NAME/spec.ezs
				mkdir -p /root/masternode/${CRYPTO_NAME}/
	# CHAINCOIN.CONF
				
			cp -p /usr/local/ezlite/lib/config/config.env  /root/masternode/${CRYPTO_NAME}/${CRYPTO_NAME}.conf		
				sed -i "s|RPCCOIN|$CRYPTO_NAME-RPC|g"  /root/masternode/${CRYPTO_NAME}/${CRYPTO_NAME}.conf ;
				sed -i "s|RPCPASS|$rd_passwd|g"  /root/masternode/${CRYPTO_NAME}/${CRYPTO_NAME}.conf ;
				sed -i "s|RPCPORT|$RPC_PORT|g"  /root/masternode/${CRYPTO_NAME}/${CRYPTO_NAME}.conf ;
				sed -i "s|MN_GENKEY|$mn_genkey|g"  /root/masternode/${CRYPTO_NAME}/${CRYPTO_NAME}.conf ;
				sed -i "s|MN_ADDR|$mn_address|g"  /root/masternode/${CRYPTO_NAME}/${CRYPTO_NAME}.conf ;
				sed -i "s|MN_PORT|$MN_PORT|g"  /root/masternode/${CRYPTO_NAME}/${CRYPTO_NAME}.conf ;
				sed -i "s|CRYPTO_NAME|${CRYPTO_NAME}|g"  /root/masternode/${CRYPTO_NAME}/${CRYPTO_NAME}.conf ;
				sed -i "s|CODE_NAME|${CODE_NAME}|g"  /root/masternode/${CRYPTO_NAME}/${CRYPTO_NAME}.conf ;
	# MASTERNODE.CONF	
			cp -p /usr/local/ezlite/lib/config/masternode.env  /root/masternode/${CRYPTO_NAME}/masternode.conf ;
				sed -i "s|MN_ALIAS|$(hostname)|g"  /root/masternode/${CRYPTO_NAME}/masternode.conf ;
				sed -i "s|MN_ADDR|$mn_address|g"  /root/masternode/${CRYPTO_NAME}/masternode.conf ;
				sed -i "s|MN_PORT|$MN_PORT|g"  /root/masternode/${CRYPTO_NAME}/masternode.conf ;
				sed -i "s|MN_GENKEY|$mn_genkey|g"  /root/masternode/${CRYPTO_NAME}/masternode.conf ;
				sed -i "s|TX_HASH|$tx_hash|g"  /root/masternode/${CRYPTO_NAME}/masternode.conf ;
				sed -i "s|TX_ID|$tx_id|g"  /root/masternode/${CRYPTO_NAME}/masternode.conf ;	
}
# START DEAMON
start_deamon(){
	if [ -z "$(ls -A /root/ezlite/installed/ )" ]; then
	   echo "Ban chua cai dat MASTERNODE nao ca."
	   exit
	else
	echo "Vui long chon coin ban muon start deamon"
	list_ins=$(ls /root/ezlite/installed/ )
	select CODE_NAME in $list_ins; do
		if [ -n "$CODE_NAME" ]; then		
	source /usr/local/ezlite/cryptos/${CODE_NAME}/spec.ezs
	$MN_DEAMON --conf=/root/masternode/${CRYPTO_NAME}/${CRYPTO_NAME}.conf
	sleep 3 ;
		fi
	break
	done
	fi
}
# Start MASTERNODE 
start_mn(){
	if [ -z "$(ls -A /root/ezlite/installed/ )" ]; then
	   echo "Ban chua cai dat MASTERNODE nao ca."
	   exit
	else
	echo "Vui long chon coin ban muon start masternode"
	list_ins=$(ls /root/ezlite/installed/ )
	select CODE_NAME in $list_ins; do
		if [ -n "$CODE_NAME" ]; then	
	input_walletpassphrase
	source /usr/local/ezlite/cryptos/$CODE_NAME/spec.ezs	
	$MN_CLI --conf=/root/masternode/${CRYPTO_NAME}/${CRYPTO_NAME}.conf ${UNLOCK_MN} $walletpassphrase 32000000
	$MN_CLI --conf=/root/masternode/${CRYPTO_NAME}/${CRYPTO_NAME}.conf ${START_MN} $walletpassphrase
	sleep 3 ;
		fi		
	done
	break
	fi
}
# Status masternode
status_mn(){
	if [ -z "$(ls -A /root/ezlite/installed/ )" ]; then
	   echo "Ban chua cai dat MASTERNODE nao ca."
	   exit
	else
	echo "Vui long chon coin ban muon xem status"
	list_ins=$(ls /root/ezlite/installed/ )
	select CODE_NAME in $list_ins; do
		if [ -n "$CODE_NAME" ]; then	
	input_walletpassphrase
	source /usr/local/ezlite/cryptos/$CODE_NAME/spec.ezs
	$MN_CLI --conf=/root/masternode/${CRYPTO_NAME}/${CRYPTO_NAME}.conf ${STATUS_MN}
	sleep 3 ;
		fi		
	done
	break
	fi
}
# Getbalance
balance_mn(){
	if [ -z "$(ls -A /root/ezlite/installed/ )" ]; then
	   echo "Ban chua cai dat MASTERNODE nao ca."
	   exit
	else
	echo "Vui long chon coin ban muon start deamon"
	list_ins=$(ls /root/ezlite/installed/ )
	select CODE_NAME in $list_ins; do
		if [ -n "$CODE_NAME" ]; then		
	source /usr/local/ezlite/cryptos/${CODE_NAME}/spec.ezs
	$MN_DEAMON --conf=/root/masternode/${CRYPTO_NAME}/${CRYPTO_NAME}.conf ${BALANCE_MN}
	sleep 3 ;
		fi		
	done
	break
	fi	
}

function daily_rp() {
cat << "EOF" >> /urs/local/ezlite/cron/${CODE_NAME}.sh
#!/bin/bash"
source SOURCE_MN
BALANCE=$($MN_CLI --conf=/root/masternode/${CRYPTO_NAME}/${CRYPTO_NAME}.conf ${BALANCE_MN})
DATE=$(date +%d-%m-%y)
echo -e "$DATE,$BALANCE" >> ${CODE_NAME}.csv              				
EOF
sed -i "s|SOURCE_MN|${CODE_NAME}|g"  /urs/local/ezlite/cron/${CODE_NAME}.sh
echo -e  "0 0 * * *  /urs/local/ezlite/cron/${CODE_NAME}.sh | mail -s "REPORT DAILY ${CODE_NAME}" contact@nguyencon.info." >> /etc/crontab
}
# Pause
pause(){
  read -p "Press [Enter] key to continue..." fackEnterKey
 }
#Install Masternode 
install_masternode(){	
	tput clear
	show_main_banner
	input_crypto_name	
	check_cryptos		
	input_genkey
	input_txhash
	input_txid
	create_config	
	echo " $gre Compile deamon $CRYPTO_NAME $end "
	build_${CRYPTO_NAME}
	daily_rp
	touch /root/ezlite/installed/${CODE_NAME}	
}


delete_ezlite(){
	read -r -p " $red Ban co chac muon go cai dat EZLITE script ? [y/N]} $end" response
	    case "$response" in
        [yY][eE][sS]|[yY]) 
			rm -rf /usr/local/ezlite/ 
			rm -rf /root/ezlite/
			rm -rf /usr/bin/ezlite
			echo -e "$gre Go bo thanh cong EZLITE !"
			;;
        *) exit ;;
    esac
}

install_quick(){
	while read wpsite           
	do           
		ee site create $phpsite --mysql --php
	done < phpsite.txt n  

}

# MENU   ##########################################################
# Main Menu
function display_main_menu(){
	show_main_banner
	tput cup 15 15
		echo "1. Cai dat nhanh"
	tput cup 15 16
		echo "2. Cai dat Masternode" 
	tput cup 16 17
		echo "3. Quan ly Masternode" 
	tput cup 17 18
		echo "4. Delete EZ-Masternode" 
	tput cup 18 19
		echo "5. Exit"
	tput bold
}
# Action Main Menu
function action_main_menu(){
        local choice
        read -p "Enter choice [ 1 - 4] " choice
        case $choice in
                1)  install_quick ;;
				2)	install_masternode ;;				
                3)  display_sub_menu1 
                    action_sub_menu1 ;;
                4)  delete_ezlite ;;
                5)      exit 0 ;;
                *) echo -e "$red $error Phim chon sai. Vui long chon lai ! $end" && sleep 2 ;;
        esac
}
# Sub-menu1
function display_sub_menu1(){
	tput clear
	show_main_banner
	tput cup 15 15
		echo "1. Start Deamon" 
	tput cup 16 15
		echo "2. Start Masternode "
	tput cup 17 15
		echo "3. Status Masternode "
	tput cup 18 15
		echo "4. Balance" 
	tput cup 19 15
		echo "5. Exit"
	tput bold
}
# Action Sub-Menu-1
function action_sub_menu1(){
        local choice
        read -p "Enter choice [ 1 - 5] " choice
        case $choice in
                1)      start_deamon && sleep 3 ;;
                2)      start_mn  && sleep 3 ;;               
                3)     	status_mn 	&& sleep 3 ;; 						
                4)      balance_mn && sleep 3 ;; 
                5)      exit 0;;
                *) echo -e "$red $error Phim chon sai. Vui long chon lai ! $end" && sleep 1
        esac
}
################
# Trap CTRL+C, CTRL+Z and quit singles
#trap '' SIGINT SIGQUIT SIGTSTP
# LOGIC
	while true
	do	
		tput clear
		show_main_banner
		display_main_menu
		action_main_menu
	done