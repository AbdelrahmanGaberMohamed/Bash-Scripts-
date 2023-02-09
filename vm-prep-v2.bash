#!/bin/bash
#Script Name: Essentials.sh
#Purpose: 
# 1) Configure Network
# 2) Update the system to the latest version and install the following tools:
#		telnet, vim, bash-completion, traceroute, tcpdump, firewalld, unzip,  wget, curl, net-tools, git
# 3) Set timeZone to Africa/Cairo configure time sync with ntp
# OS: Centos-8-Stream
#Author: Abdelrahman Gaber
#Date: 9/2/2023
#Exit Codes:
#	0: Success
#Welcome message 
echo " Starting server initial configuration "
# Variables 
CON_NAME=$(nmcli c s| cut -f 1 -d " "| grep -v "NAME")
echo "Enter IPV4 Address/SubnetMask: "
read IP
echo "Enter Gateway IP: "
read GW
echo "Enter NTP server IP: "
read NTP
###############################################################################################################
echo "Configuring ...."
#Configure Network
nmcli con mod ${CON_NAME} ifname ${CON_NAME} type ethernet ip4 ${IP} gw4 ${GW} connnection.autoconnect yes
systemctl restart NetworkManager.service
#Update system and install essential tools
yum update -y 
yum install -y telnet vim bash-completion traceroute tcpdump firewalld unzip  wget curl net-tools git chrony 
systemctl enable --now firewalld.service 
systemctl enable --now chronydservice

#Configure Time-Zone and sync
datetimectl set-timezone Africa/Cairo
sed -i "s/pool.*/server ${NTP}/g" /etc/chrony.conf
systemctl restart chronyd.service

echo "Done. BYE :)"

exit 0