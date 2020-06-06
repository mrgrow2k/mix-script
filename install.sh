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
echo -e "\n===============================================================\
         \n   ${GRAY} ██████╗ ██╗   ██╗██████╗ ███╗   ██╗ ██████╗ ██████╗ ███████╗   ${NC} \
         \n   ${GRAY} ██╔══██╗██║   ██║██╔══██╗████╗  ██║██╔═══██╗██╔══██╗██╔════╝   ${NC} \
         \n   ${GRAY} ██║  ██║██║   ██║██████╔╝██╔██╗ ██║██║   ██║██║  ██║█████╗     ${NC} \
         \n   ${GRAY} ██║  ██║██║   ██║██╔═══╝ ██║╚██╗██║██║   ██║██║  ██║██╔══╝     ${NC} \
         \n   ${GRAY} ██████╔╝╚██████╔╝██║     ██║ ╚████║╚██████╔╝██████╔╝███████╗   ${NC} \
         \n   ${GRAY} ╚═════╝  ╚═════╝ ╚═╝     ╚═╝  ╚═══╝ ╚═════╝ ╚═════╝ ╚══════╝   ${NC} \
     \n                                                   ╗ made by ${GREEN}mrgrow2k${NC} ╔\
     \n===================================================================\
     \n                                                                    "
echo ""
echo "1.  Ragnarok Node    - Install ragnarok node & bootstrap"
echo "2.  Worx Node        - Install worx node & bootstrap"
echo "3.  Dupe Node        - Install dupnode script"
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
  FANCY_NAME='Ragnarok Node'
  SCRIPT_NAME='ragna_node'
fi
if [ "$choice" -eq "2" ]; then
  FANCY_NAME='Worx Node'
  SCRIPT_NAME='worx_node'
fi
if [ "$choice" -eq "3" ]; then
  FANCY_NAME='Dupe Node'
  SCRIPT_NAME='dupmn_install'
fi

clear
echo "${RED}$FANCY_NAME${NC} Script starting, please wait..."
clear
sudo wget "https://raw.githubusercontent.com/mrgrow2k/mix-script/master/$SCRIPT_NAME.sh"
chmod +x $SCRIPT_NAME.sh
sudo ./$SCRIPT_NAME.sh
  
# echo ""
# read -p "You are about to install ${RED}$FANCY_NAME${NC}, do you wish to continue? " -n 1 -r
# if [[ ! $next_choice =~ ^[Yy]$ ]]; then
#   echo -e "\n"
#   clear
#   echo "${RED}$FANCY_NAME${NC} Script starting, please wait..."
#   clear
#   sudo wget "https://raw.githubusercontent.com/mrgrow2k/mix-script/master/$SCRIPT_NAME.sh"
#   chmod +x $SCRIPT_NAME.sh
#   sudo ./$SCRIPT_NAME.sh
# fi