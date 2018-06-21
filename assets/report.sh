#!/bin/bash 
	source /usr/local/ezmn/assets/source.ezs
	DAEMON_RUN=$(ls -1 /root/ezmn/running/ | sed -e 's/\.pid$//')
for CODE_NAME  in $DAEMON_RUN  ; do
	source ${LS_CRYPTOS}/${CODE_NAME}/spec.ezs
	source $DIR_EZMN/cmd/CMD-${GROUP}.ezs
	DATE=$(date +%d-%m-%y)
	BALANCE=$(${WL_BALANCE})
	echo -e "$DATE ; $BALANCE" >> /root/ezmn/report/${CODE_NAME}.csv
done