#!/bin/bash
# DIR 
EZ_DIR=/usr/local/ezlite
EZ_DATA=/root/ezlite
MN_DIR=/root/masternode
# SOURCE 
for assets in $EZ_DIR/assets/*.ezs ; do source $assets; done
mn_address=$(ip route get 1 | awk '{print $NF;exit}');
rd_passwd=$(date +%s | sha256sum | base64 | head -c 32 ;);
wl_passwd=$(date +%s | sha256sum | base64 | head -c 16 ;);

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