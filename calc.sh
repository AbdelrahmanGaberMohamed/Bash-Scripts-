#!/bin/bash
### Calculator for both integer and floating point numbers, 
### Arguments: 1st operand , operation, 2nd operation
### Output: Scripts returns result based on operation specified by the operation argument 
### Exit Codes:
#       0: Normal termination
#       1: Insufficient parameters
#       2: operand is not a number
#       3: Invalid operation
#       4: 2nd operand is Zero (in case of division only)
### Function to check if the value is a number, takes one paramter which is the value to be checked
function ISNUM {
        local CHK=$(echo "${1}" | grep -c "[^0-9]")
        return ${CHK}
}
### Check if the user has entered 3 paramters
if [ ${#} -ne 3 ]
then
                echo "Insufficient paramters"
                exit 1
fi
OP1=${1}
OP2=${3}
OP=${2}
### Check that the input values are integers
ISNUM ${OP1}
if [ ${?} -eq 1 ]
then
        echo "Invalid input"
        exit 2
fi
ISNUM ${OP2}
if [ ${?} -eq 1 ]
then
        echo "Invalid input"
        exit 2
fi
### Check the input operation and calculate the result accordingly
case "${OP}" in
        "+")
                RES=$[OP1+OP2]
                ;;
        "-")
                RES=$[OP1-OP2]
                ;;
        "x")
                RES=$[OP1*OP2]
                ;;
        "/")
                if [ ${OP2} -eq 0 ]
                then
                        echo "Math error: Division by zero"
                        exit 4
                fi
                RES=$(printf %.4f\\n "$((1000 * ${OP1}/${OP2}  ))e-3")
                ;;
        *)
                echo "Invalid operation"
                exit 3
                ;;
esac
echo "Result = ${RES}"
exit 0
