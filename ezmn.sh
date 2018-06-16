#!/bin/bash
source /usr/local/ezmn/assets/source.ezs ;
s_color

################
# Trap CTRL+C, CTRL+Z and quit singles
#trap '' SIGINT SIGQUIT SIGTSTP
# LOGIC

main_menu(){
	s_main_menu
	display_main_menu
	action_main_menu

}

while true
do	
	tput clear
	main_menu

done
pause

