#!/bin/bash

echo "Installing curl and jq..."
sudo apt-get install -y curl jq >/dev/null 2>&1

TMP_FOLDER=$(mktemp -d)
CONFIG_FILE='ragnarok.conf'
CONFIGFOLDER='/root/.ragnarok'
COIN_DAEMON='ragnarokd'
COIN_CLI='ragnarok-cli'
COIN_PATH='/usr/local/bin/'

COIN_TGZ_URL=$(curl -s https://api.github.com/repos/ragnaproject/Ragnarok/releases/latest | grep browser_download_url | grep -e "ragnarok-.*x86_64-linux-static.tar.gz" | cut -d '"' -f 4)
COIN_TGZ_VPS=$(echo "$COIN_TGZ_URL" | cut -d "/" -f 9)

BOOTSTRAPURL=$(curl -s https://api.github.com/repos/ragnaproject/bootstraps/releases/latest | grep browser_download_url | grep -e "bootstrap.tar.gz" | cut -d '"' -f 4)
BOOTSTRAPARCHIVE="bootstrap.tar.gz"

COIN_NAME='Ragnarok'
COIN_TICKER='ragna'
COIN_PORT=8853
RPC_PORT=8854

BLUE="\033[0;34m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m" 
PURPLE="\033[0;35m"
RED='\033[0;31m'
GREEN="\033[0;32m"
NC='\033[0m'
MAG='\e[1;35m'

function install_sentinel() {
  echo -e "${GREEN}Installing sentinel.${NC}"
  apt-get -y install python-virtualenv virtualenv >/dev/null 2>&1
  git clone $SENTINEL_REPO $CONFIGFOLDER/sentinel >/dev/null 2>&1
  cd $CONFIGFOLDER/sentinel
  virtualenv ./venv >/dev/null 2>&1
  ./venv/bin/pip install -r requirements.txt >/dev/null 2>&1
  echo  "* * * * * cd $CONFIGFOLDER/sentinel && ./venv/bin/python bin/sentinel.py >> $CONFIGFOLDER/sentinel.log 2>&1" > $CONFIGFOLDER/$COIN_NAME.cron
  crontab $CONFIGFOLDER/$COIN_NAME.cron
  rm $CONFIGFOLDER/$COIN_NAME.cron >/dev/null 2>&1
}

function download_node() {
  echo -e "${GREEN}Downloading and Installing VPS $COIN_NAME Daemon${NC}"
  wget $COIN_TGZ_URL >/dev/null 2>&1

  compile_error
  sudo tar -xzvf $COIN_TGZ_VPS -C $COIN_PATH >/dev/null 2>&1
  compile_error
  rm $COIN_TGZ_URL >/dev/null 2>&1
  clear
}

function bootstrap() {
  echo -e "${CYAN}Doandling & Installing Bootstrap...${NC}"
  cd $CONFIGFOLDER
  sudo wget $BOOTSTRAPURL >/dev/null 2>&1
  compile_error
  sudo tar xvzf $BOOTSTRAPARCHIVE >/dev/null 2>&1
  rm $BOOTSTRAPARCHIVE
}


function configure_systemd() {
  cat << EOF > /etc/systemd/system/$COIN_TICKER.service
[Unit]
Description=$COIN_NAME service
After=network.target

[Service]
User=root
Group=root

Type=forking
#PIDFile=$CONFIGFOLDER/$COIN_NAME.pid

ExecStart=$COIN_PATH$COIN_DAEMON -daemon -txindex -conf=$CONFIGFOLDER/$CONFIG_FILE -datadir=$CONFIGFOLDER
ExecStop=-$COIN_PATH$COIN_CLI -conf=$CONFIGFOLDER/$CONFIG_FILE -datadir=$CONFIGFOLDER stop

Restart=always
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=10s
StartLimitInterval=120s
StartLimitBurst=5

[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload
  sleep 3
  systemctl start $COIN_TICKER.service
  systemctl enable $COIN_TICKER.service >/dev/null 2>&1

  if [[ -z "$(ps axo cmd:100 | egrep $COIN_DAEMON)" ]]; then
    echo -e "${RED}$COIN_NAME is not running${NC}, please investigate. You should start by running the following commands as root:"
    echo -e "${GREEN}systemctl start $COIN_TICKER.service"
    echo -e "systemctl status $COIN_TICKER.service"
    echo -e "less /var/log/syslog${NC}"
    exit 1
  fi
}


function create_config() {
  mkdir $CONFIGFOLDER >/dev/null 2>&1
  RPCUSER=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w14 | head -n1)
  RPCPASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w25 | head -n1)
  cat << EOF > $CONFIGFOLDER/$CONFIG_FILE
rpcuser=$RPCUSER
rpcpassword=$RPCPASSWORD
rpcport=$RPC_PORT
rpcallowip=127.0.0.1
txindex=1
debug=0
listen=1
server=1
daemon=1
maxconnections=256
EOF
}


function enable_firewall() {
  echo -e "Installing and setting up firewall to allow ingress on port ${GREEN}$COIN_PORT${NC}"
  ufw allow $COIN_PORT/tcp comment "$COIN_NAME MN port" >/dev/null
  ufw allow ssh comment "SSH" >/dev/null 2>&1
  ufw limit ssh/tcp >/dev/null 2>&1
  ufw default allow outgoing >/dev/null 2>&1
  echo "y" | ufw enable >/dev/null 2>&1
}


function compile_error() {
if [ "$?" -gt "0" ];
 then
  echo -e "${RED}Failed to compile $COIN_NAME. Please investigate.${NC}"
  exit 1
fi
}


function checks() {
if [[ $(lsb_release -d) != *16.04* ]]; then
  echo -e "${RED}You are not running Ubuntu 16.04. Installation is cancelled.${NC}"
  exit 1
fi

if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}$0 must be run as root.${NC}"
   exit 1
fi

if [ -n "$(pidof $COIN_DAEMON)" ] || [ -e "$COIN_DAEMOM" ] ; then
  echo -e "${RED}$COIN_NAME is already installed.${NC} Please Run again.."
  exit 1
fi
}

function prepare_system() {
echo -e "Preparing the VPS to setup. ${CYAN}$COIN_NAME${NC} ${RED}Daemon${NC}"
apt-get update >/dev/null 2>&1
DEBIAN_FRONTEND=noninteractive apt-get update > /dev/null 2>&1
DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y -qq upgrade >/dev/null 2>&1
apt install -y software-properties-common >/dev/null 2>&1
echo -e "${PURPLE}Adding bitcoin PPA repository"
apt-add-repository -y ppa:bitcoin/bitcoin >/dev/null 2>&1
echo -e "Installing required packages, it may take some time to finish.${NC}"
apt-get update >/dev/null 2>&1
apt-get install -y libzmq3-dev  >/dev/null 2>&1
apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" make software-properties-common \
build-essential libtool autoconf libssl-dev libboost-dev libboost-chrono-dev libboost-filesystem-dev libboost-program-options-dev \
libboost-system-dev libboost-test-dev libboost-thread-dev sudo automake git wget libdb4.8-dev bsdmainutils libdb4.8++-dev \
libminiupnpc-dev libgmp3-dev ufw pkg-config libevent-dev  libdb5.3++ unzip libzmq5 >/dev/null 2>&1
if [ "$?" -gt "0" ];
  then
    echo -e "${RED}Not all required packages were installed properly. Try to install them manually by running the following commands:${NC}\n"
    echo "apt-get update"
    echo "apt -y install software-properties-common"
    echo "apt-add-repository -y ppa:bitcoin/bitcoin"
    echo "apt-get update"
    echo "apt install -y curl jq make build-essential libtool software-properties-common autoconf libssl-dev libboost-dev libboost-chrono-dev libboost-filesystem-dev \
libboost-program-options-dev libboost-system-dev libboost-test-dev libboost-thread-dev sudo automake git libdb4.8-dev \
bsdmainutils libdb4.8++-dev libminiupnpc-dev libgmp3-dev ufw pkg-config libevent-dev libdb5.3++ unzip libzmq5"
 exit 1
fi
clear
}

function important_information() {
 echo
 echo -e "${CYAN}=======================================================================================${NC}"
 echo -e "Configuration file is: ${RED}$CONFIGFOLDER/$CONFIG_FILE${NC}"
 echo -e "Start: ${RED}systemctl start $COIN_TICKER.service${NC}"
 echo -e "Stop: ${RED}systemctl stop $COIN_TICKER.service${NC}"
 echo -e "Check Status: ${RED}systemctl status $COIN_TICKER.service${NC}"
 echo -e "Use ${RED}$COIN_CLI help${NC} for help."
 echo -e "${YELLOW}=====================================================================================${NC}"
 if [[ -n $SENTINEL_REPO  ]]; then
 echo -e "${RED}Sentinel${NC} is installed in ${RED}/root/sentinel_$COIN_NAME${NC}"
 echo -e "Sentinel logs is: ${RED}$CONFIGFOLDER/sentinel.log${NC}"
 echo -e "${CYAN}=======================================================================================${NC}"
 fi
}

function setup_node() {
  create_config
  bootstrap
  enable_firewall
  #install_sentinel
  important_information
  configure_systemd
}


##### Main #####
clear

checks
prepare_system
download_node
setup_node
