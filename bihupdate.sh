echo -e "Downloading Bithost Latest"
cd /tmp
wget -N https://github.com/nur0m/BitHost/releases/download/v1.0.1.0/bithost-linux-upgrade.tar.gz
tar xvzf bithost-linux-upgrade.tar.gz
clear
echo -e "Updating Bithost to the latest version"
systemctl stop bithost
mv bithostd bithost-cli /usr/local/bin
rm xvzf bithost-linux-upgrade.tar.gz
clear
echo -e "Starting Bithost daemon, please be patient"
systemctl start bithost
clear
sleep 10
bithost-cli getinfo
echo -e "Update completed, have a nice day :)"
