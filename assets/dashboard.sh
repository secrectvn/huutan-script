#!/bin/bash
	mn_address=$(ip route get 1 | awk '{print $NF;exit}');
	DEAMON_RUN=$(ls -1 /root/ezlite/running/ | sed -e 's/\.pid$//')
	echo -e "╔════════════════════════════════════════════════════════════════════╗"
	printf "%s %-15s %-2s %-10s %-2s %-35s %-2s\n" ║ CRYPTO_NAME ║ BALANCE ║ MN_STATUS ║ 
	for CODE_NAME  in $DEAMON_RUN  ; do
	source /usr/local/ezlite/cryptos/${CODE_NAME}/spec.ezs
	MN_CMD="$MN_CLI --datadir=/root/masternode/${CRYPTO_NAME}/ --conf=/root/masternode/${CRYPTO_NAME}/${CRYPTO_NAME}.conf"
	BALANCE=$(${MN_CMD} ${BALANCE_MN})
	STATUS=$(${MN_CMD} ${STATUS_MN} | grep -E 'message|notCapableReason' | tr -d '"' |  awk '{print $3, $4, $5}')		
	echo -e "══════════════════════════════════════════════════════════════════════"
	printf "%s %-15s %-2s %-10.2f %-2s %-35s %-2s\n" ║ "${CRYPTO_NAME}" ║ "$BALANCE" ║ "$STATUS" ║ 
done
	echo -e "╚════════════════════════════════════════════════════════════════════╝"
	
	
	
