#!/bin/bash
source /usr/local/ezmn/source.ezs ;

################
# Trap CTRL+C, CTRL+Z and quit singles
#trap '' SIGINT SIGQUIT SIGTSTP
# LOGIC
while true
do	
	s_main_menu	
	display_main_menu
	action_main_menu
done

