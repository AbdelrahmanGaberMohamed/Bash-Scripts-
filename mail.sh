#!/bin/bash
######This script checks emails files for emails and validates their format
###### Valid format is [alpha][.or_][alphanum]@[alpha].[com,net,org]
####Exit codes:
#	0: Success
#	1: File doesnt exist 
# 	2: File unreadable 
# 	3: unvalid format 

echo -n "Enter file name: " 
read ENAME
if [ ! -f ${ENAME} ] 
then 
	echo "File doesnt exist"
	exit 1
fi 
if [ ! -r ${ENAME} ]
then 
	echo "File unreadable"
	exit 2
fi

for INDEX in To: From:										##Extract To and From headers 
do
	EMAIL=$(grep  "^${INDEX}" ${ENAME} | cut -f2 -d :)					##Extract Email from header
#	echo "${EMAIL}"
	USR=$( echo "${EMAIL}" | cut -f1 -d @)							##Extract user field
#	echo "${USR}" 
	USRVLD=$( echo "${USR}" | grep "^[[:alpha:]]\{1,\}[[:alnum:]]" | wc -l )		##User must start with alpha 
	USRPVLD=$( echo "${USR}" | grep [[:punct:]] | grep -v [._-_] | wc -l )			##User can only have _-. punct characters
#	echo "${USRVLD}"
#	echo "${USRPVLD}"
	if [ ${USRVLD} -ne 1 ] || [ ${USRPVLD} -ne 0 ] 						##Check if user field in Email satisfies the valid format
	then 
		echo "Invalid email format"
		exit 3 
	fi 

#	echo "${USR}"
	DOM=$( echo "${EMAIL}" | cut -f2 -d @ | cut -f1 -d .)					##Extract Domain field from the Email
#	echo "${DOM}"
	DOMVLD=$( echo "${DOM}" | grep "^[[:alpha:]]\{1,\}[[:alnum:]]"| wc -l)			##Domain must start with alpha and be alphanum
#	echo "${DOMVLD}"
	if [ ${DOMVLD} -ne 1 ]									##Check if Domain field satisfies the valid format 
	then
		echo "Invalid Email Format"
		exit 3
	fi
	EXT=$( echo "${EMAIL}" | cut -f2 -d @ | cut -f2 -d .)					##Exteact the .com field 
	echo "${EXT}"
	EXTVLD=$( echo "${EXT}" | grep "net\|com\|org\|edu" | wc -l  )				##Field must contain one of the following (net,com,org,edu)
      	if [ ${EXTVLD} -ne 1 ]									##Check if it satisfies the valid condition
	then 
		echo "Invalid Email Format"
		exit 3
	fi	

done
echo "Email format is valid"							##Print valid if both sender and reciver Emails satisfies the valid format
exit 0
