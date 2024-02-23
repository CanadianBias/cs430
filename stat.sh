#!/bin/bash

# A program that accepts a string and return statistics
# how many vowel, consonants, numbers, spaces, punctuation

# Check for a command line argument or request one

if [[ $# -gt 0 ]]; then
	string=$*
else
	echo -n "Enter a string: "
	read string
fi

# This loops breaks string into words instead of chars
# Bash is reading the string as a space seperated list, so each item is a word
#for char in $string; do
	#echo $char
#done

for ((i=0;i<=${#string};i++)); do # the ${#string} returns the length of an array
	#echo ${string:i:1} # first colon represents starting index, second colon represents length
	char=${string:i:1}
	case $char in
		[aAeEiIoOuU] ) ((vowels++));;
		[qQwWrRtTyYpPsSdDfFgGhHjJkKlLzZxXcCvVbBnNmM] ) ((cons++));;
		[0-9] ) ((nums++));;
		[.,?!] ) ((punc++));;
		# [!../] | [:..@] | [\.._] ) ((punc++));;
		" " ) ((spaces++));;
		# * ) ((cons++));;
	esac
done

# Output the results
echo "Vowels: $vowels"
echo "Numbers: $nums"
echo "Punctuation: $punc"
echo "Spaces: $spaces"
echo "Consonants: $cons"
