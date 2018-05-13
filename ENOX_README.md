# Enox
Shell script to install a [Enox Masternode](http://enox.io) on a Linux server running Ubuntu 16.04.
***

## Installation
```
wget -q https://raw.githubusercontent.com/growbtcprofits/mix-script/master/enox_install.sh
bash enox_install.sh
```
***

## Desktop wallet setup  

After the MN is up and running, you need to configure the desktop wallet accordingly. Here are the steps:  
1. Open the enox Desktop Wallet.  
2. Go to RECEIVE and create a New Address: **MN1**  
3. Send **1000** Enox to **MN1**. You need to send all 1000 coins in one single transaction.
4. Wait for 15 confirmations.  
5. Go to **Help -> "Debug Window - Console"**  
6. Type the following command: **masternode outputs**  
7. Go to  **Tools -> "Open Masternode Configuration File"**
8. Add the following entry:
```
Alias Address Privkey TxHash TxIndex
```
* Alias: **MN1**
* Address: **VPS_IP:21001**
* Privkey: **Masternode Private Key**
* TxHash: **First value from Step 6**
* TxIndex:  **Second value from Step 6**
9. Save and close the file.
10. Go to **Masternode Tab**. If you tab is not shown, please enable it from: **Settings - Options - Wallet - Show Masternodes Tab**
11. Click **Update status** to see your node. If it is not shown, close the wallet and start it again. Make sure the wallet is un
12. Select your MN and click **Start Alias** to start it.
13. Alternatively, open **Debug Console** and type:
```
masternode start-alias MN1
```

## Usage:
```
alias enoxd1="enoxd1 -datadir=/root/.enox1"

alias enoxd2="enoxd2 -datadir=/root/.enox2"

alias enoxd3="enoxd3 -datadir=/root/.enox3"
```

**That is if you install 3 nodes on one VPS** 

## To use the command just you have to do something like this 

```
enoxd1 -datadir=/root/.enox1 getblockcount
enoxd1 -datadir=/root/.enox1 getinfo
enoxd1 -datadir=/root/.enox1 masternode status
```
