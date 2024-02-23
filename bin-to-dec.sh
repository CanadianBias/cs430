#!/bin/bash

# Converts a number from binary to decimal or from decimal to binary

# function to convert from binary to decimal

function bin2dec {
	# assigns binary number passed to variable
	local binNum=$1
	# sets place to index of rightmost binary place value (ones place)
	local place=${#binNum}
	((place--))
	# assignment that takes more meaning inside loop
	local digit=0
	local placeValue=1
	local decNum=0

	for ((i=0;i<=$place;i++)); do	# iterates until it reaches value of place, meaning the index would equal zero
		# digit holds whether or not the value at the specified place is a 1 or a 0
		digit=${binNum:place-i:1}
		# decNum holds the final value of the conversion
		# takes the current value of decNum, and if the value is a 1, adds the power of 2 of the current place to decNum
		decNum=$[decNum+(placeValue*digit)]
		# increments placeValue to move to the next power of 2
		((placeValue*=2))
	done
	# call output
	echo $decNum
}

function bin2decShort {
	local binNum=$1
	for ((i=0;i<=${#binNum}-1;i++)); do
		decNum=$[decNum+(${binNum:i:1}*(2**(${#binNum}-i-1)))]
	done
	echo $decNum
}

# function to convert from decimal to binary
# In order to find the first power of 2 that decNum can be divided by, we need to find the first power of 2 that is greater than the value of decNum
# Iterate through a loop that runs through the powers of 2 while the power of 2 is less than the value of decNum
# Store the last power of 2 that was greatest
# Assign a length of the required number of binary place values that that power of 2 requires

# Check to see if inidividual characters in a number can be modified like an indexed string

function dec2bin {
	local decNum=$1
	local placeValue=1
	#local binLen=1
	while [[ $placeValue -le $decNum ]]; do
		((placeValue*=2))
		#((binLen++))
	done
	((placeValue/=2))
	#((binLen--))
	local binNum=""
	while [[ $placeValue -ge 1 ]]; do
		if [[ $decNum-$placeValue -ge 0 ]]; then
			decNum=$[decNum-placeValue]
			binNum+="1" # Correct syntax obtained from Bing Copilot, prompt: "Concatenate a string of numeric values in bash"
			#((binNum+="1")) also the wrong syntax, but correctly counts how many ones are present in the binary number
			#${binNum:binIndex}=1 wrong syntax, unsure how to fix
		else
			binNum+="0"
			#((binNum+="0"))
			#${binNum:binIndex}=0
		fi
		((placeValue/=2))
	done

	# Find left base
	# workthrough number reducing left base
	# pad number to have a multiple of 4 digits

	echo $binNum
}

echo "What type of conversion would you like to complete?"
echo "1) Binary to Decimal"
echo "2) Decimal to Binary"
echo -n "Select an Option: "
read binOrDec

if [[ $binOrDec -eq 1 ]]; then
	echo -n "Enter the binary number you'd like to convert to decimal (without spaces): "
	read binNum
	decNum=$(bin2dec $binNum)
	echo -n "The decimal representation of "
	echo -n $binNum
	echo -n " is "
	echo $decNum
elif [[ $binOrDec -eq 2 ]]; then
	echo -n "Enter the decimal number you'd like to convert to binary: "
	read decNum
	binNum=$(dec2bin $decNum)
	echo -n "The binary represenation of "
	echo -n $decNum
	echo -n " is "
	echo $binNum
else
	echo "Error: an option was not selected."
fi


# debugging code
# code needed to use the functions 
#binNum=10110011
#decNum=196
#decNum=$(bin2dec $binNum)
#decNum=$(bin2decShort $binNum)
#binNum=$(dec2bin $decNum)
#echo $decNum
#echo $binNum
