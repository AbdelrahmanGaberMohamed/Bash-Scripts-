#!/bin/bash
### This scripts reads the a file and returns it's content numbered line-by-line
### Exit codes:	
#	0: Normal termination
#	1: File doesn't exist
#	2: File unreadable 
FILE=${1}
if [ ! -f  ${FILE} ]                          ## Check if file exists
then 
	echo "No such file"
	exit 1 
fi 
if [ ! -r ${FILE} ]							  ## Check if file is readable		
then 
	echo "No permission to read this file"
	exit 2
fi 
COUNT=1										## Initiate line count =1  									  
PAGE=$(cat ${FILE})							## Put file content in a variable 			
for INDEX in ${PAGE}						## Loop over each line 
do 
	echo "${COUNT}: ${INDEX}"				## print out line number followed by line 
	COUNT=$[COUNT+1]						## Increasae line count by 1 
done 
exit 0
