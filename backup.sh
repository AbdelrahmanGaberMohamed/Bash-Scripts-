#!/bin/bash 
###This script makes a backup of my home file 
###Exit Codes:
#	0: Success 


if [ ! -d /tmp/backup ]									##Check if /tmp/backup dir exists 
then 
	mkdir /tmp/backup								##If not create /tmp/backup
fi 
if [ -f /tmp/backup/myhomebackup.tar.gz ]						##Check if the system has old backups 
then 
	mv /tmp/backup/myhomebackup.tar.gz /tmp/backup/myhomebackup-old.tar.gz 		##If it has rename the old backup to myhmoebackup-old.tar.gz
fi

tar -czf /tmp/backup/myhomebackup.tar.gz /home/user					##Create a backup for /home/user (user's home dir)

rsync /tmp/backup/myhomebackup.tar.gz 192.168.1.8:~/backups				##Transfer the backup to host of ip 192.168.1.8
#echo "${?}"
if [ ${?} -eq 255 ]									##255 is rsync exit code for ssh connection timeout
then
	logger -p local1.err "Remote Backup Failed, Couldn't establish SSH connection"	##In case of backup faliure create a log for it 
fi
exit 0
