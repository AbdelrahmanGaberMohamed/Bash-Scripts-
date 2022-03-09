#!/bin/bash 
### This script accepts file or direcctory as input:
## if the input is file it will return file size and number of lines 
## if the input is dir it will return the size and number of files for each file in it 
### Exit codes:
#	0: Norman termination
#	1: File or dir doesn't exist 
#	2: file or dir is not readable 
#	3: dir is empty 

INPUT=${1}
if [ -f ${INPUT} ] 			## Check if input is a file 
then 	
	if [ ! -r ${INPUT} ]		## Check if file is readable 
	then
		echo "No read permission" ## If not readable prompt user and exit 
		exit 2
	fi
	LINES=$(cat ${INPUT} | wc -l)	## Get number of lines in a file 
	SIZE=$(du -h ${INPUT} | cut -f1) ## Get file size 
	echo -e "File: ${INPUT}\nSize: ${SIZE}\nLines #: ${LINES}"  ## print file name file size and number of lines 
	exit 0
fi 
if [ -d ${INPUT} ] 	## If the input is not file check if it is a dir 
then 
	if [ ! -r ${INPUT} ] 	## check if dir is readable 
	then 
		echo "No read permission" ## if not readable prompt user and exit 
		exit 2 
	fi 
	FILES=$(ls ${INPUT})	## Store file names in a variable 
	for INDEX in ${FILES}   ## Loop over each file in the dir 
	do 
		LINES=$(cat ${INPUT}/${INDEX} | wc -l)	## get no. of lines in the file 
        	SIZE=$(du -h ${INPUT}/${INDEX} | cut -f1) ## get file size 
		echo "File Name      Size        Number of lines" ## print a table of file names, size, and number of lines 
        	echo "${INDEX}       ${SIZE}               ${LINES}"
	done 
	exit 0
fi 
echo "No such file or directory" ## If the input is not the name of a file or a dir 
exit 1 				## prompt the user and exit 
