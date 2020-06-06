#!/bin/bash
clear

NC=$'\e[0m'
RED=$'\e[31;01m'
GREEN=$'\e[32;01m'
YELLOW=$'\e[33;01m'
BLUE=$'\e[34;01m'
PURPLE=$'\e[35;01m'
CYAN=$'\e[36;01m'

echo ""
echo -e "\n================================================================================\
         \n   ${GRAY} ██████╗ ██╗   ██╗██████╗ ███╗   ██╗ ██████╗ ██████╗ ███████╗   ${NC} \
         \n   ${GRAY} ██╔══██╗██║   ██║██╔══██╗████╗  ██║██╔═══██╗██╔══██╗██╔════╝   ${NC} \
         \n   ${GRAY} ██║  ██║██║   ██║██████╔╝██╔██╗ ██║██║   ██║██║  ██║█████╗     ${NC} \
         \n   ${GRAY} ██║  ██║██║   ██║██╔═══╝ ██║╚██╗██║██║   ██║██║  ██║██╔══╝     ${NC} \
         \n   ${GRAY} ██████╔╝╚██████╔╝██║     ██║ ╚████║╚██████╔╝██████╔╝███████╗   ${NC} \
         \n   ${GRAY} ╚═════╝  ╚═════╝ ╚═╝     ╚═╝  ╚═══╝ ╚═════╝ ╚═════╝ ╚══════╝   ${NC} \
     \n                                                   ╗ made by ${GREEN}mrgrow2k${NC} ╔\
     \n====================================================================================\
     \n                                                                                   "
echo ""
echo "1.  Just Node        - Install single node & bootstrap"
echo "2.  Dupe Node        - Install dupnode script"
echo ""
read -p "Which node do you want to install: " choice

if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
	echo "Enter only numbers. Exiting..."
	exit 1
elif [ "$choice" -gt "8" ] || [ "$choice" -le "0" ]; then
	echo "You need to enter a number above. Exiting..."
	exit 1
fi

if [ "$choice" -eq "1" ]; then
  FANCY_NAME='Just Node'
  SCRIPT_NAME='vps_node'
fi
if [ "$choice" -eq "2" ]; then
  FANCY_NAME='Dupe Node'
  SCRIPT_NAME='dup_install'
fi


echo ""
read -p "You are about to install ${RED}$FANCY_NAME${NC}, do you wish to continue? " -n 1 -r
if [[ ! $next_choice =~ ^[Yy]$ ]]; then
  echo -e "\n"
  clear
  echo "${RED}$FANCY_NAME${NC} Script starting, please wait..."
  clear
  sudo wget "https://raw.githubusercontent.com/mrgrow2k/mix-script/master/$SCRIPT_NAME.sh"
  chmod +x $SCRIPT_NAME.sh
  sudo ./$SCRIPT_NAME.sh
fi