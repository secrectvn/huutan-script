#!/bin/bash 
	DAEMON_RUN=$(ls -1 /root/ezmn/running/ | sed -e 's/\.pid$//')
for CODE_NAME  in $DAEMON_RUN  ; do
	source /usr/local/ezmn/cryptos/${CODE_NAME}/spec.ezs
	DATE=$(date +%d-%m-%y)
	BALANCE=$(${BALANCE_MN})
	echo -e "$DATE ; $BALANCE" >> /root/ezmn/report/${CODE_NAME}.csv
done