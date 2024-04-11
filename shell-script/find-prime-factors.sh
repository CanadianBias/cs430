#!/bin/bash

# Takes any number of command line arguments (including zero)
# Returns the prime factors for each number

# Functions
# Check if a number is prime
function is-prime {
	local number=$1
	local prime=1
	if [[ $number -lt 2 ]]; then
		prime=0
	fi
	# eliminate even numbers
	if [[ $number%2 -eq 0 && $number -ne 2 ]]; then
		prime=0
	else
		local factor=3
		# checks up to square root of number
		while [[ $factor*$factor -le $number ]]; do
			if [[ $number%$factor -eq 0 ]]; then
				prime=0
			fi
			((factor+=2))
		done
	fi
	echo $prime
}

# Check for command line arguments, otherwise execute on all arguments
if [[ $# -eq 0 ]]; then
	echo -n "Enter a number: "
	read num
	# Determine prime factors
	echo -n "The prime factors of $num are: "
	# Checks first to see if the number is prime, and skips the rest if it is prime
	if [[ $(is-prime $num) -eq 1 ]]; then
		echo -n "$num "
	else
		# Optimizes by only checking for the first even factor and returns 2
		if [[ $num%2 -eq 0 ]]; then
			echo -n "2 "
			half=$[num/2]
			if [[ $(is-prime $half) -eq 1 ]]; then
				echo -n "$half "
			fi
		fi
		# Checks for all odd factors
		for ((i=3;i*i<=num;i+=2)); do
			if [[ $num%$i -eq 0 ]]; then
				#check if prime
				if [[ $(is-prime $i) -eq 1 ]]; then
					echo -n "$i "
				fi
				highNum=$[num/i]
				if [[ $(is-prime $highNum) -eq 1 ]]; then
					echo -n "$highNum "
				fi
			fi
		done
	fi
	echo ""
else
	# For each number, determine factors, then determine if they are prime
	for arg in $*; do
		echo -n "The prime factors of $arg are: "
		# Checks first to see if arg is prime
		if [[ $(is-prime $arg) -eq 1 ]]; then
			echo -n $arg
		else
			# Checks for all possible factors that are divisible by 2
			# Optimizes by not checking all factors divisible by 2
			if [[ $arg%2 -eq 0 ]]; then
				echo -n "2 "
				half=$[arg/2]
				if [[ $(is-prime $half) -eq 1 ]]; then
					echo -n "$half "
				fi
			fi
			# Checks for all possible odd factors
			for ((n=3;n*n<=arg;n+=2)); do
				if [[ $arg%$n -eq 0 ]]; then
					if [[ $(is-prime $n) -eq 1 ]]; then
						echo -n "$n "
					fi
					highFact=$[arg/n]
					if [[ $(is-prime $highFact) -eq 1 ]]; then
						echo -n "$highFact "
					fi
				fi
			done
		fi
		echo ""
	done
fi
