#!/bin/bash
# DIR 
EZ_SOURCE=/usr/local/ezlite
EZ_DATA=/root/ezlite
MN_DIR=/root/masternode
# SOURCE 
source $EZ_SOURCE/assets/banner.ezs
# VAR
MN_OPTION=$(--data=$MN_DIR/${CRYPTO_NAME}/ --conf=$MN_DIR/${CRYPTO_NAME}/${CRYPTO_NAME}.conf)
mn_address=$(ip route get 1 | awk '{print $NF;exit}');
rd_passwd=$(date +%s | sha256sum | base64 | head -c 32 ;);
# ACTION ##########################################################

# INPUT CODE NAME
input_code_name(){
read -p  " $gre Nhap ten CODENAME ( viet thuong ) cua coin do :  $end " CODE_NAME
}
# INPUT WALLETPASS
input_walletpassphrase(){
read -p  " $gre Nhap Walletpassphrase  :  $end " walletpassphrase
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
# CHECK PROJECT
check_project(){		
if [ -r $EZ_SOURCE/cryptos/${CODE_NAME}/spec.ezs ];
	then		
		mkdir -p $MN_DIR/${CRYPTO_NAME}/
	else
		echo "$red MASTERNODE chua duoc ho tro. Vui long cho doi ban update tiep theo ! $end"
		exit 0 ;
	fi
}
# CREATE CONFIG
create_config(){
				source $EZ_SOURCE/cryptos/${CODE_NAME}/spec.ezs
				mkdir -p $MN_DIR/${CRYPTO_NAME}/
	# CHAINCOIN.CONF
				
			cp -p $EZ_SOURCE/assets/config/config.env  $MN_DIR/${CRYPTO_NAME}/${CRYPTO_NAME}.conf		
				sed -i "s|RPCCOIN|$CRYPTO_NAME-RPC|g"  $MN_DIR/${CRYPTO_NAME}/${CRYPTO_NAME}.conf ;
				sed -i "s|RPCPASS|$rd_passwd|g"  $MN_DIR/${CRYPTO_NAME}/${CRYPTO_NAME}.conf ;
				sed -i "s|RPCPORT|$RPC_PORT|g"  $MN_DIR/${CRYPTO_NAME}/${CRYPTO_NAME}.conf ;
				sed -i "s|MN_GENKEY|$mn_genkey|g"  $MN_DIR/${CRYPTO_NAME}/${CRYPTO_NAME}.conf ;
				sed -i "s|MN_ADDR|$mn_address|g"  $MN_DIR/${CRYPTO_NAME}/${CRYPTO_NAME}.conf ;
				sed -i "s|MN_PORT|$MN_PORT|g"  $MN_DIR/${CRYPTO_NAME}/${CRYPTO_NAME}.conf ;
				sed -i "s|CRYPTO_NAME|${CRYPTO_NAME}|g"  $MN_DIR/${CRYPTO_NAME}/${CRYPTO_NAME}.conf ;
				sed -i "s|CODE_NAME|${CODE_NAME}|g"  $MN_DIR/${CRYPTO_NAME}/${CRYPTO_NAME}.conf ;
	# MASTERNODE.CONF	
			cp -p $EZ_SOURCE/assets/config/masternode.env  $MN_DIR/${CRYPTO_NAME}/masternode.conf ;
				sed -i "s|MN_ALIAS|$(hostname)|g"  $MN_DIR/${CRYPTO_NAME}/masternode.conf ;
				sed -i "s|MN_ADDR|$mn_address|g"  $MN_DIR/${CRYPTO_NAME}/masternode.conf ;
				sed -i "s|MN_PORT|$MN_PORT|g"  $MN_DIR/${CRYPTO_NAME}/masternode.conf ;
				sed -i "s|MN_GENKEY|$mn_genkey|g"  $MN_DIR/${CRYPTO_NAME}/masternode.conf ;
				sed -i "s|TX_HASH|$tx_hash|g"  $MN_DIR/${CRYPTO_NAME}/masternode.conf ;
				sed -i "s|TX_ID|$tx_id|g"  $MN_DIR/${CRYPTO_NAME}/masternode.conf ;	
}
# START MASTERNODE lan dau
start_deamon(){
	input_code_name	
	source $EZ_SOURCE/cryptos/${CODE_NAME}/spec.ezs	
	$MN_DEAMON $MN_OPTION && sleep 3
}
# START MASTERNODE 
start_mn(){
	input_code_name
	input_walletpassphrase
	source $EZ_SOURCE/cryptos/${CODE_NAME}/spec.ezs	
	$MN_CLI $MN_OPTION ${START_MN} $walletpassphrase
	sleep 3;
}
# REPORT MASTERNODE
daily_rp(){
cat << "EOF" >> $EZ_DATA/balance/${CODE_NAME}.sh
#!/bin/bash
source SOURCE_MN
BALANCE=$($MN_CLI $MN_OPTION ${BALANCE_MN})
DATE=$(date +%d-%m-%y)
echo -e "$DATE ; $BALANCE " >> $EZ_DATA/report/${CODE_NAME}.csv              				
EOF
sed -i "s|SOURCE_MN|${CODE_NAME}|g"  $EZ_DATA/balance/${CODE_NAME}.sh
chmod +x $EZ_DATA/balance/${CODE_NAME}.sh
echo -e  "0 0 * * *  $EZ_DATA/balance/${CODE_NAME}.sh | mail -s "REPORT DAILY ${CODE_NAME}" contact@nguyencon.info." >> /etc/crontab
}

# Status masternode
status_mn(){
	input_code_name
	source $EZ_SOURCE/cryptos/${CODE_NAME}/spec.ezs	
	$MN_CLI $MN_OPTION ${STATUS_MN} 
}
# Getbalance
balance_mn(){
	input_code_name
	source $EZ_SOURCE/cryptos/${CODE_NAME}/spec.ezs		
	$MN_CLI $MN_OPTION ${BALANCE_MN}
}
# Pause 
pause(){
  read -p "Press [Enter] key to continue..." fackEnterKey
}

#Install Masternode 
install_masternode(){	
	tput clear
	show_main_banner
	input_code_name	
	check_project		
	input_genkey
	input_txhash
	input_txid
	create_config	
	echo " $gre Compile deamon $CRYPTO_NAME $end "
	build_${CRYPTO_NAME}
	daily_rp
	touch $EZ_DATA/installed/${CODE_NAME}
	
}
delete_ezlite(){
	read -r -p " $red Ban co chac muon go cai dat EZLITE script ? [y/N]} $end" response
	    case "$response" in
        [yY][eE][sS]|[yY]) 
			rm -rf $EZ_SOURCE/
			rm -rf $EZ_DATA/
			rm -rf /usr/bin/ezlite
			echo -e "$gre Go bo thanh cong EZLITE !"
			;;
        *) exit ;;
    esac
}

# MENU   ##########################################################
# Main Menu
function display_main_menu(){
	show_main_banner
	tput cup 15 15
		echo "1. Cai dat Masternode" 
	tput cup 16 15
		echo "2. Quan ly Masternode" 
	tput cup 17 15
		echo "3. Delete EZ-Masternode" 
	tput cup 18 15
		echo "4. Exit"
	tput bold
}
# Action Main Menu
function action_main_menu(){
        local choice
        read -p "Enter choice [ 1 - 4] " choice
        case $choice in
                1)      install_masternode ;;
                2)      display_sub_menu1 
                        action_sub_menu1 ;;
                3)    	delete_ezlite ;;
                4)      exit 0 ;;
                *) echo -e "$red $error Phim chon sai. Vui long chon lai ! $end" && sleep 1
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
                1)      start_deamon && sleep 5 ;;
                2)      start_mn  && sleep 5 ;;               
                3)     	status_mn 	&& sleep 5 ;; 						
                4)      balance_mn && sleep 5 ;; 
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
