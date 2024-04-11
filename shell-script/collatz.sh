#!/bin/bash
#
#Returns the number less than the number given as a command line argument with the longest Collatz sequence as well as a count of the total number of steps in the sequence.

#Check for CLAs
#Error checking for incorrect amount of CLAs
#Store value from CLA to variable

#Calculate collatz length for all numbers up to maximum
#Keeping track of the number of steps, move through the collatz sequence
#If the number is even, divide by 2
#If the number is odd, multiply by 3 and add 1
#Stop when you reach one
#Store the length and the highest value of the longest
#Compare the current length to the stored longest length
#Keep the longer length of the two

if [[ $# -eq 1 ]]; then
	maximum_number=$1
else
	echo -n "Enter a maximum number to check for the longest Collatz length: "
	read maximum_number
fi

greatest_steps=0
longest_collatz=$maximum_number
current_steps=0

while [[ $maximum_number -gt 1 ]]
do
	testNum=$maximum_number
	while [[ $testNum -gt 1 ]]
	do
		if [[ $testNum%2 -eq 0 ]]; then
			testNum=$[$testNum/2]
		else
			testNum=$[$testNum*3+1]
		fi
		(( current_steps++ ))
	done
	if [[ $current_steps -gt $greatest_steps ]]; then
		greatest_steps=$current_steps
		longest_collatz=$maximum_number
	fi
	current_steps=0
	(( maximum_number-- ))
done

echo "${longest_collatz} was the number with the longest Collatz sequence, with ${greatest_steps} steps."
