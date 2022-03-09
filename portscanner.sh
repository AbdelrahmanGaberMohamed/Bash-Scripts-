#!/bin/bash
### this scripts scans all IPs on the network for open ports 
### Exit codes:
#	0: Normal termination
IP=$(ifconfig -a | grep "inet" | cut -f10 -d ' ' | grep ^[[:digit:]] | cut -f1,2,3 -d '.')
for NET in ${IP}
do 
	for HOST in $(seq 1 254)
	do 
		ping -c4 ${NET}.${HOST}
		if [ ${?} -eq 0 ]
		then 
	 		echo "${NET}.${HOST} is active"
			nmap ${NET}.${HOST} 
		else 
			echo "${NET}.${HOST} is down"
		fi 
 	done 
done 

exit 0 



