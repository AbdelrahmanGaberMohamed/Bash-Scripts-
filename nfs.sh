#!/bin/bash
### This script is the task i was given in my ITI graduation project
### This script auto configures nfs-server for web, mail, and database servers 
###The script must be run as root 
### Exit Codes:
#       0: Set-up successful 
#       1: Can't enable nfs-server.service
## Set host name
hostnamectl set-hostname storage
# Find all connected NICs and prompt user to choose one to be used to set up a new connection
NIC=$(ip a | grep ens)
echo "${NIC}"
echo "Enter your desired NIC name: "
read NIC
## Set up connection named Storage 
nmcli con add con-name "Storage" ifname ${NIC} type ethernet ipv4.addresses 10.0.1.10/24 ipv4.gateway 10.0.1.1 ipv4.dns 10.0.1.2 ipv4.method manual connection.autoconnect yes
nmcli con down Storage
nmcli con up Storage
## Prompt user to choose which devices to be used to create volume group and logical volumes to be used as remote storage 
echo " $(lsblk) "
echo "Enter your desired devices: "
read DEV
for INDEX in ${DEV}
do
        pvcreate /dev/${INDEX}
done
DEV=$( pvs | grep /dev | cut -f3 -d ' ' )
vgcreate vg01 ${DEV}
## Create logical volume for each server type [web, mail ,data base]
lvcreate --name web -l 33%FREE /dev/vg01
lvcreate --name mail -l 50%FREE /dev/vg01
lvcreate --name dbase -l 100%FREE /dev/vg01
mkfs.xfs /dev/mapper/vg01-web
mkfs.xfs /dev/mapper/vg01-mail
mkfs.xfs /dev/mapper/vg01-dbase
## Create mounting points 
                                         mkdir -p /mnt/{web,mail,dbase}
## Configure persistent mounting 
echo "/dev/mapper/vg01-web /mnt/web xfs defaults 0 0" >> /etc/fstab
echo "/dev/mapper/vg01-mail /mnt/mail xfs defaults 0 0" >> /etc/fstab
echo "/dev/mapper/vg01-dbase /mnt/dbase xfs defaults 0 0" >> /etc/fstab
## mount all
mount -a
# Install nfs-server 
yum install nfs-utils -y
# configure firewall and enable nfs-server.service 
firewall-cmd --add-service=nfs --permanent
firewall-cmd --reload
systemctl enable --now nfs-server
ENB=$(systemctl is-enabled nfs-server.service)
if [ ${ENB} == "disabled" ]
then
        echo "Error enabling nfs-server"
        exit
fi
touch /etc/exports
echo "/mnt/web 10.0.1.6(rw,no_root_squash) 10.0.1.7(rw,no_root_squash)">>/etc/exports
echo "/mnt/mail  10.0.1.8(rw,no_root_squash) 10.0.1.9(rw,no_root_squash">>/etc/exports
echo "/mnt/dbase  10.0.1.12(rw,no_root_squash)">>/etc/exports



exit 0

                         