#!/bin/bash
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
	source /usr/local/ezlite/assets/banner.ezs
	source /usr/local/ezlite/assets/menu.ezs
	tput clear
	tput smcup
	show_main_banner 
	display_main_menu
	action_main_menu
done

