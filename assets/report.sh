#!/bin/bash 
	DEAMON_RUN=$(ls -1 /root/ezlite/running/ | sed -e 's/\.pid$//')
for CODE_NAME  in $DEAMON_RUN  ; do
	source /usr/local/ezlite/cryptos/${CODE_NAME}/spec.ezs
	BALANCE=$($MN_CLI --datadir=/root/masternode/${CRYPTO_NAME}/ --conf=/root/masternode/${CRYPTO_NAME}/${CRYPTO_NAME}.conf ${BALANCE_MN})
	DATE=$(date +%d-%m-%y)
	echo -e "$DATE ; $BALANCE" >> /root/ezlite/balance/${CODE_NAME}.csv
done