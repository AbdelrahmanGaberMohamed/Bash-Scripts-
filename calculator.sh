#!/bin/bash
#Script_name: calculator.sh
#Purpose: Preform arithmetic operation on two nmubers depending on user input
#Author: Abdelrahman Gaber
#Exit Codes:
#  0: User exit

while true
do

  echo "1. ADD"
  echo "2. Subtract"
  echo "3. Multiply"
  echo "4. Divide"
  echo "5. Quit"
  read -p "Choose operation: " option

  if [ $option -eq 1 ]
  then
    read -p "Enter Number1: " num1
    read -p "Enter Number2: " num2
    echo "Answer=$((num1 + num2))
  elif [ $option -eq 2 ]
  then
    read -p "Enter Number1: " num1
    read -p "Enter Number2: " num2
    echo "Answer=$((num1 - num2))
  elif [ $option -eq 3 ]
  then
    read -p "Enter Number1: " num1
    read -p "Enter Number2: " num2
    echo "Answer=$((num1 * num2))
  elif [ $option -eq 4 ]
  then
    read -p "Enter Number1: " num1
    read -p "Enter Number2: " num2
    echo "Answer=$((num1 / num2))
  elif [ $option -eq 2 ]
  then
   echo "Exiting Calculator"
   break
  else
    echo "Invalid input"
    continue
  fi
done
exit 0
