#!/bin/bash
# DIR 
EZ_DIR=/usr/local/ezlite
EZ_DATA=/root/ezlite
MN_DIR=/root/masternode
# SOURCE 
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
		source $EZ_DIR/assets/banner.ezs
		source $EZ_DIR/assets/menu.ezs
		show_main_banner
		display_main_menu
		action_main_menu
	done