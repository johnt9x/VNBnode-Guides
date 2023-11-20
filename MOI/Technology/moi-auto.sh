#!/bin/bash
exists()
{
  command -v "$1" >/dev/null 2>&1
}
if exists curl; then
echo ''
else
  sudo apt update && sudo apt install curl -y < "/dev/null"
fi

# Logo
sleep 1 && curl -s https://raw.githubusercontent.com/vnbnode/VNBnode-Guides/main/logo.sh | bash && sleep 1

# Pull image new
echo -e "\e[1m\e[32m4. Pull image... \e[0m" && sleep 1
SelectVersion="Please choose: \n 1. CPU from 2015 or later\n 2. CPU from 2015 or earlier"
echo -e "${SelectVersion}"
read -p "Enter index: " version;
if [ "$version" != "2" ];then
	docker pull sarvalabs/moipod:latest
else
	docker pull sarvalabs/moipod:v0.3.0-port
fi
sleep 1

# Allow port 30333
echo -e "\e[1m\e[32m5. Allow Port 1600 and 6000... \e[0m" && sleep 1
sudo ufw allow 1600/tcp
sudo ufw allow 6000/tcp
sudo ufw allow 6000/udp
sleep 1

# Fill data
echo -e "\e[1m\e[32m6. Fill data... \e[0m" && sleep 1

## DIR_PATH
if [ ! $moi_dirpath ]; then
    read -p "DIR_PATH: " moi_dirpath
    echo 'export moi_dirpath='\"${moi_dirpath}\" >> $HOME/.bash_profile
fi
echo 'source $HOME/.bashrc' >> $HOME/.bash_profile
source $HOME/.bash_profile
sleep 1

#$ KEYSTORE_PATH
if [ ! $moi_keystore ]; then
    read -p "KEYSTORE_PATH: " moi_keystore
    echo 'export moi_keystore='\"${moi_keystore}\" >> $HOME/.bash_profile
fi
echo 'source $HOME/.bashrc' >> $HOME/.bash_profile
source $HOME/.bash_profile
sleep 1

## PASSWD
if [ ! $moi_passwd ]; then
    read -p "PASSWORD KEYSTORE DOWNLOADED: " moi_passwd
    echo 'export moi_passwd='\"${moi_passwd}\" >> $HOME/.bash_profile
fi
echo 'source $HOME/.bashrc' >> $HOME/.bash_profile
source $HOME/.bash_profile
sleep 1

## ADDRESS
if [ ! $moi_address ]; then
    read -p "ADDRESS: " moi_address
    echo 'export moi_address='\"${moi_address}\" >> $HOME/.bash_profile
fi
echo 'source $HOME/.bashrc' >> $HOME/.bash_profile
source $HOME/.bash_profile
sleep 1

## INDEX
if [ ! $moi_index ]; then
    read -p "KRAMA ID INDEX: " moi_index
    echo 'export moi_index='\"${moi_index}\" >> $HOME/.bash_profile
fi
echo 'source $HOME/.bashrc' >> $HOME/.bash_profile
source $HOME/.bash_profile
sleep 1

## IP
if [ ! $moi_ip ]; then
    read -p "IP PUBLIC: " moi_ip
    echo 'export moi_ip='\"${moi_ip}\" >> $HOME/.bash_profile
fi
echo 'source $HOME/.bashrc' >> $HOME/.bash_profile
source $HOME/.bash_profile
sleep 1

# Register the Guardian Node
echo -e "\e[1m\e[32m7. Register the Guardian Node... \e[0m" && sleep 1
SelectVersion="Please choose: \n 1. CPU from 2015 or later\n 2. CPU from 2015 or earlier"
echo -e "${SelectVersion}"
read -p "Enter index: " version;
if [ "$version" != "2" ];then
	sudo docker run -p 1600:1600/tcp -p 6000:6000/tcp -p 6000:6000/udp --rm -it -w /data -v $(pwd):/data sarvalabs/moipod:latest register --data-dir $moi_dirpath --mnemonic-keystore-path $moi_keystore/keystore.json --watchdog-url https://babylon-watchdog.moi.technology/add --node-password $moi_passwd --network-rpc-url https://voyage-rpc.moi.technology/babylon --wallet-address $moi_address --node-index $moi_index --local-rpc-url http://$moi_ip:1600
else
	sudo docker run -p 1600:1600/tcp -p 6000:6000/tcp -p 6000:6000/udp --rm -it -w /data -v $(pwd):/data sarvalabs/moipod:v0.3.0-port register --data-dir $moi_dirpath --mnemonic-keystore-path $moi_keystore/keystore.json --watchdog-url https://babylon-watchdog.moi.technology/add --node-password $moi_passwd --network-rpc-url https://voyage-rpc.moi.technology/babylon --wallet-address $moi_address --node-index $moi_index --local-rpc-url http://$moi_ip:1600
fi
sleep 1

# Start the Guardian Node
echo -e "\e[1m\e[32m8. Start the Guardian Node... \e[0m" && sleep 1
SelectVersion="Please choose: \n 1. CPU from 2015 or later\n 2. CPU from 2015 or earlier"
echo -e "${SelectVersion}"
read -p "Enter index: " version;
if [ "$version" != "2" ];then
	sudo docker run --name moi -p 1600:1600/tcp -p 6000:6000/tcp -p 6000:6000/udp -it -d -w /data -v $(pwd):/data sarvalabs/moipod:latest server --babylon --data-dir $moi_dirpath --log-level DEBUG --node-password $moi_passwd 
else
	sudo docker run --name moi -p 1600:1600/tcp -p 6000:6000/tcp -p 6000:6000/udp -it -d -w /data -v $(pwd):/data sarvalabs/moipod:v0.3.0-port server --babylon --data-dir $moi_dirpath --log-level DEBUG --node-password $moi_passwd
fi
sleep 1

NAMES=`docker ps | egrep 'sarvalabs/moipod' | awk '{print $18}'`
rm $HOME/moi-auto.sh

# Command check
echo '====================== SETUP FINISHED ======================'
echo -e "\e[1;32mView the logs from the running: \e[0m\e[1;36msudo docker logs -f ${NAMES}\e[0m"
echo -e "\e[1;32mCheck the list of containers: \e[0m\e[1;36msudo docker ps -a\e[0m"
echo -e "\e[1;32mStart your avail node: \e[0m\e[1;36msudo docker start ${NAMES}\e[0m"
echo -e "\e[1;32mRestart your avail node: \e[0m\e[1;36msudo docker restart ${NAMES}\e[0m"
echo -e "\e[1;32mStop your avail node: \e[0m\e[1;36msudo docker stop ${NAMES}\e[0m"
echo -e "\e[1;32mRemove avail: \e[0m\e[1;36msudo docker rm ${NAMES}\e[0m"
echo '============================================================='