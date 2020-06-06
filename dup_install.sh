#!/bin/bash

readonly GRAY='\e[1;30m'
readonly GREEN='\e[1;32m'
readonly YELLOW='\e[1;33m'
readonly CYAN='\e[1;36m'
readonly NC='\e[0m'


function echo_json_upd() {
	echo -e "$1"
	[[ -t 3 ]] && echo -e "{\"message\":\"$(echo "$1" | sed 's/\\e\[[0-9;]*m//g')\",\"retcode\":$2}" >&3
}


echo -e "\n================================================================================\
         \n   ${GRAY} ██████╗ ██╗   ██╗██████╗ ███╗   ██╗ ██████╗ ██████╗ ███████╗   ${NC} \
         \n   ${GRAY} ██╔══██╗██║   ██║██╔══██╗████╗  ██║██╔═══██╗██╔══██╗██╔════╝   ${NC} \
         \n   ${GRAY} ██║  ██║██║   ██║██████╔╝██╔██╗ ██║██║   ██║██║  ██║█████╗     ${NC} \
         \n   ${GRAY} ██║  ██║██║   ██║██╔═══╝ ██║╚██╗██║██║   ██║██║  ██║██╔══╝     ${NC} \
         \n   ${GRAY} ██████╔╝╚██████╔╝██║     ██║ ╚████║╚██████╔╝██████╔╝███████╗   ${NC} \
         \n   ${GRAY} ╚═════╝  ╚═════╝ ╚═╝     ╚═╝  ╚═══╝ ╚═════╝ ╚═════╝ ╚══════╝   ${NC} \
		 \n                                               ╗ made by ${GREEN}mrgrow2k${NC} ╔\
		 \n================================================================================\
		 \n                                                                               "

dup_update=%h/mix-script/dupnode.sh

if [[ -f /usr/bin/dupnode && ! $(diff -q <(echo "$dup_update") /usr/bin/dupnode) ]]; then
	echo_json_upd "${GREEN}dupnode${NC} is already updated to the last version" 0
else
	echo -e "Checking needed dependencies..."
	if [[ ! $(command -v lsof) ]]; then
		echo -e "Installing ${CYAN}lsof${NC}..."
		sudo apt-get install lsof
	fi
	if [[ ! $(command -v curl) ]]; then
		echo -e "Installing ${CYAN}curl${NC}..."
		sudo apt-get install curl
	fi

	if [[ ! -d ~/.dupnode ]]; then
		mkdir ~/.dupnode
	fi
	touch ~/.dupnode/dupnode.conf

	update=$([[ -f /usr/bin/dupnode ]] && echo "1" || echo "0")

	echo "$dupnode_update" > /usr/bin/dupnode
	chmod +x /usr/bin/dupnode

	if [[ $update == "1" ]]; then
		echo_json_upd "${GREEN}dupnode${NC} updated to the last version, pretty fast, right?" 1
	else
		echo_json_upd "${GREEN}dupnode${NC} installed, pretty fast, right?" 2
	fi
fi

echo ""
