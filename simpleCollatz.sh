#!/bin/bash

#echo -n "Enter a number"
max=$1

steps=0

while [[ $max -gt 1 ]]
do
	if [[ $max%2 -eq 0 ]]; then
		max=$[max/2]
	else
		max=$[3*max+2]
	fi
	steps=$[steps+1]
done

echo $steps
