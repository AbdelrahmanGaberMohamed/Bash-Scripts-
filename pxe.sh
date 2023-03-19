#!/bin/bash
#Script Name: PXE-Server
#Purpose: Configure PXE-Server for automatic OS installtion over network 
#Author: Abdelrahman Gaber
#Date: 6/3/2023
#OS: CentOS-7 (Didn't test for later versions)
#Exit Codes:
#	0: Success
#	1: DHCP Service failed
#Variable Definitions:
#IP_POOL				(IP range used for DHCP)
#GW						(DHCP Network Gateway IP)
#PXE_IP				    (PXE-Server IP)
#SUBNET					(DHCP subnet)
#NETMASK				(DHCP subnet netmask)
#IP_START				(DHCP IP Range Start)
#IP_END				    (DHCP IP Range End)
#BC_IP					(DHCP Network BroadCast IP)
#PASSWD					(Root Password)
#ENC_PASS				(Encrypted Password)
#CHK_DHCP				(1: DHCP is running, 0: DHCP is dead)
#Package installation 
yum update -y 		    #update system (optional)
yum install -y dhcp install dhcp tftp tftp-server syslinux vsftpd xinetd
#Configure DHCP
echo -e "ddns-update-style interim;\nignore client-updates;\nauthoritative;\nallow booting;\nallow bootp;\nallow unknown-clients;\n" >> /etc/dhcp/dhcpd.conf
whiptail --msgbox --title "Welocome" "Starting VM Setup ..." --fb 10 70
SUBNET=$(whiptail --inputbox --title "DHCP" "Enter DHCP Network: " --fb 10 70 3>&1 1>&2 2>&3)
NETMASK=$(whiptail --inputbox --title "DHCP" "Enter DHCP Network Mask: " --fb 10 70 3>&1 1>&2 2>&3)
IP_START=$(whiptail --inputbox --title "DHCP" "Enter DHCP Pool Start: " --fb 10 70 3>&1 1>&2 2>&3)
IP_END=$(whiptail --inputbox --title "DHCP" "Enter DHCP Pool End: " --fb 10 70 3>&1 1>&2 2>&3)
GW=$(whiptail --inputbox --title "DHCP" "Enter Network Gateway: " --fb 10 70 3>&1 1>&2 2>&3)
BC_IP=$(whiptail --inputbox --title "DHCP" "Enter Network BroadCast IP: " --fb 10 70 3>&1 1>&2 2>&3)
PXE_IP=$(whiptail --inputbox --title "DHCP" "Enter Network PXE-Server IP: " --fb 10 70 3>&1 1>&2 2>&3)
echo -e "subnet ${SUBNET} netmask ${NETMASK}\n{\n range ${IP_START} ${IP_STOP};\n option routers ${GW};\n option broadcast-address ${BC_IP};\n default-lease-time 60000;\n max-lease-time 72000;\n next-server ${PXE_IP};\n filename \"pxelinux.0\";\n}" >> /etc/dhcp/dhcpd.conf
systemctl enable --now dhcpd.service
#DHCP Service health check
CHK_DHCP=$(systemctl status dhcpd | grep running | wc -l)
if [ ${CHK_DHCP} -eq 0 ]
then
	echo "dhcp.service failed"
	exit 1
fi
#Mount The ISO image to /var/ftp/pub
echo "/dev/sr0 /var/ftp/pub/ iso9660 defaults 0 0" >> /etc/fstab
mount -a
#Copy network boot files
cp  -v /usr/share/syslinux/pxelinux.0 /var/lib/tftpboot
cp  -v /usr/share/syslinux/menu.c32 /var/lib/tftpboot
cp  -v /usr/share/syslinux/memdisk /var/lib/tftpboot
cp  -v /usr/share/syslinux/mboot.c32 /var/lib/tftpboot
cp  -v /usr/share/syslinux/chain.c32 /var/lib/tftpboot
#make two directories /var/lib/tftpboot/networkboot/ /var/lib/tftpboot/pxelinux.cfg/	
mkdir /var/lib/tftpboot/{networkboot,pxelinux.cfg}
#Copy kernel and initrd files to /var/lib/tftpboot/networkboot/
cp /var/ftp/pub/images/pxeboot/{vmlinuz,initrd.img} /var/lib/tftpboot/networkboot/.
#Create PXE menu file
echo -e "default menu.c32\nprompt 0\ntimeout 30\nMENUU TITLE PXE\nLABEL centos7_x64\nMENU LABEL CentOS_X64\nKERNEL /networkboot/vmlinuz\nAPPEND initrd=/networkboot/initrd.img inst.repo=ftp://${PXE_IP}/pub ks=ftp://${PXE_IP}/ks.cfg" >> /var/lib/tftpboot/pxelinux.cfg/default
#Configure Firewall and selinuix
firewall-cmd --add-service={ftp,dhcp,tftp} --permanent
firewall-cmd --add-port={69/tcp,69/udp,4011/udp} --permanent
firewall-cmd --reload
setsebool -P allow_ftpd_full_access 1
#Enable and start all services
sed -i "s/disable.*/disable = no" /etc/xinetd.d/tftp
systemctl enable --now xinetd vsftpd
cp /root/ks.cfg /var/ftp/.
whiptail --title "END OF Confiuration" --msgbox "BYE :)" --fb 8 78 
exit 0

