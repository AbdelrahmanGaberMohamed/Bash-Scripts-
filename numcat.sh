#!/bin/bash
### This scripts reads the a file and returns it's content numbered line-by-line
### Exit codes:	
#	0: Normal termination
#	1: File doesn't exist
#	2: File unreadable 
FILE=${1}
if [ ! -f  ${FILE} ]
then 
	echo "No such file"
	exit 1 
fi 
if [ ! -r ${FILE} ]
then 
	echo "No permission to read this file"
	exit 2
fi 
COUNT=1 
PAGE=$(cat ${FILE})
for INDEX in ${PAGE}
do 
	echo "${COUNT}: ${INDEX}"
	COUNT=$[COUNT+1]
done 
exit 0
