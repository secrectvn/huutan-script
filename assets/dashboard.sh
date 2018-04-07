#!/bin/bash
	DEAMON_RUN=$(ls -1 /root/ezlite/running/ | sed -e 's/\.pid$//')
	echo -e "╔══════════════════════════════════════╗"
	printf "%-15s %-2s %-4s %-2s\n" CRYPTO_NAME ║ BALANCE ║
	for CODE_NAME  in $DEAMON_RUN  ; do
	source /usr/local/ezlite/cryptos/${CODE_NAME}/spec.ezs
	MN_CMD="$MN_CLI --datadir=/root/masternode/${CRYPTO_NAME}/ --conf=/root/masternode/${CRYPTO_NAME}/${CRYPTO_NAME}.conf"
	BALANCE=$(${MN_CMD} ${BALANCE_MN})
	echo -e ""
	printf "%-15s %-2s %-4.2f%-2s\n" "${CRYPTO_NAME}" ║ "$BALANCE" ║
done
	echo -e "╚══════════════════════════════════════╝"




#printf "%-5s %-10s %-4s\n" 
#printf "%-5s %-s %-4.2f\n" "CRYPTO NAME" "${CRYPTO_NAME}" "$BALANCE"
#printf "%-5s %-10s %-4.2f\n" 2 James 90.9989 
#printf "%-5s %-10s %-4.2f\n" 3 Jeff 77.564