#!/bin/bash
EZ_DIR=/usr/local/ezlite
EZ_DATA=/root/ezlite
MN_DIR=/root/masternode
# REPORT

for run_mn in /root/ezlite/running/*.pid ;
	do
		CODE_NAME=$(ls -1 /root/ezlite/running/ | sed -e 's/\.pid$//')
		source $EZ_DIR/cryptos/${CODE_NAME}
		BALANCE=$($MN_CLI --datadir=$MN_DIR/${CRYPTO_NAME}/ --conf=$MN_DIR/${CRYPTO_NAME}/${CRYPTO_NAME}.conf ${BALANCE_MN})
		DATE=$(date +%d-%m-%y)	
		echo -e "$DATE ; $BALANCE" >> $EZ_DATA/balance/${CODE_NAME}.csv 
   done