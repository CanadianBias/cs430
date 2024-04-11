#!/bin/bash
# Converts any number from a base to another base

function showUsage {
	echo "baseConv.sh can convert any number from one base to another."
	echo "Usage:"
	echo "baseConv.sh with no command line arguments will prompt for information."
	echo "baseConv.sh [number] [newBase] will convert a [number] from base 10 to a [newBase]."
	echo "baseConv.sh [number] [origBase] [newBase] will convert a [number] from [original base] to [new base]."
	exit 1
}

function baseToDecimal {
	if [[ $origBase -ne 10 ]]; then
		# stores what current character is being converted to decimal
		local char=0
		# iterates over the length of the passed number
		for ((i=0;i<=${#origNum}-1;i++)); do
			#loop debugging block
			#echo -n "i is "
			#echo $i
			# case statements to convert letters in certain bases to decimal representation
			if [[ $origBase -eq 12 ]]; then
				case ${origNum:i:1} in
					[xX] ) char=10;;
					[eE] ) char=11;;
					* ) char=${origNum:i:1};;
				esac
			elif [[ $origBase -eq 16 ]]; then
				case ${origNum:i:1} in
					[aA] ) char=10;;
					[bB] ) char=11;;
					[cC] ) char=12;;
					[dD] ) char=13;;
					[eE] ) char=14;;
					[fF] ) char=15;;
					* ) char=${origNum:i:1};;
				esac
			else
				char=${origNum:i:1}
			fi
			# adds to decNum, the current character multiplied by the base of the current placevalue
			decNum=$[decNum+(char*(origBase**(${#origNum}-i-1)))] # throwing up errors
		done
	else
		decNum=$origNum
	fi
	#echo $decNum
}

function decimalToNewBase {
	local placeValue=1
	# moving up to the largest placevalue that can be pulled out from decNum
	while [[ $placeValue -le $decNum ]]; do
		((placeValue*=$newBase))
	done
	((placeValue/=$newBase))
	baseNum=""
	# moving down the placevalues now
	while [[ $placeValue -ge 1 ]]; do
		# finding how many times placevalue can be subtracted from decNum and storing it
		newDigit=$[decNum/placeValue]
		# conditionals and cases to adjust for new bases greater than 10
		if [[ $newBase -eq 12 ]]; then
			if [[ $newDigit -eq 10 ]]; then
				newDigit="x"
			elif [[ $newDigit -eq 11 ]]; then
				newDigit="e"
			fi
		elif [[ $newBase -eq 16 ]]; then
			case $newDigit in
					10 ) newDigit="A";;
					11 ) newDigit="B";;
					12 ) newDigit="C";;
					13 ) newDigit="D";;
					14 ) newDigit="E";;
					15 ) newDigit="F";;
			esac
		fi
		# storing the remainder of the line where newDigit is assigned value, to use in the next iteration of the loop
		decNum=$[decNum%placeValue]
		# adds the next digit to baseNum
		baseNum+=$newDigit
		((placeValue/=$newBase))
	done
	#echo $decNum
	#echo $baseNum
	# With base 12 and base 16 conversions, have to check more than just one digit in decimal representation
}

#Check for CLAs
case $# in
	3 ) origNum=$1; origBase=$2; newBase=$3;;
	2 ) origNum=$1; origBase=10; newBase=$2;;
	0 )
		echo -n "Enter a number to convert: "
		read origNum
		echo -n "Enter the current base: "
		read origBase
		echo -n "Enter new base: "
		read newBase;;
	* ) showUsage;;
esac

# function calls to compute and assign values to decNum and baseNum
baseToDecimal
decimalToNewBase

echo "The base $newBase representation of base $origBase number $origNum is $baseNum"
echo "Thanks for watching"

# convert to base 10 if not already there
# then convert to new base number
