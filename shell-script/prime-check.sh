#!/bin/bash

# Takes one command line argument, and checks to see whether that number is prime or not prime
# No checking for command line arguments
# Not completely optimized when number given is odd

num=$1
prime=1
if [[ $num -le 1 ]]
then
	echo "Neither Prime nor Not Prime"
	exit
elif [[ $num%2 -eq 0 && $num -ne 2 ]]
then
	echo "Not Prime"
	exit
else
	test=3
	while [[ $test -lt $num ]]
	do
		if [[ $num%$test -eq 0 && $num -ne $test ]]
		then
			echo "Not Prime"
			exit
		fi
		test=$[test+1]
	done
fi
echo "Prime"


