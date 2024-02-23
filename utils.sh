#!/bin/bash
# program to help users do stuff

function addFancyThings {
	local char=$1
	local title=$2
	local titleLen=${#title}
	local stopPoint=$[(COLUMNS-titleLen)/2]
	local line
	for ((i=0;i<$stopPoint;i++)); do
		line+=$char
	done
	line+=$title
	for ((j=${#line};j<$COLUMNS;j++)); do
		line+=$char
	done
	echo $line
}

# Loop continuously 
while [[ 1 ]]; do

	# Clean up screen
	clear

	# add a border
	addFancyThings "=" "utils.sh"

	# Present a menu of options to the user
	echo "Choose an option from the list below"
	echo "1. Display the IP address information"
	echo "2. Display the Date"
	echo "3. What do you know about me?"
	echo "4. Display a Special Date"
	echo "5. Ping an IP address a certain amount of times"
	echo "6. How long has utils.sh been open?"
	echo "7. Store the current date in a text file"
	echo "8. Find the prime factors of a number"
	echo "9. Find the length of the Collatz sequence of a number"
	#echo "10. Factors of a quadratic equation"
	echo "10. Find the nth root of a number"
	echo "0. Exit"
	echo "(Hit Ctrl+C to exit)"

	addFancyThings "-" ""

	# Get user response
	echo -n "Type the number of the option: "
	read input

	# Perform the selected operation
	case $input in
		0 ) addFancyThings "*" "Thanks for watching, Like Comment and Subscribe!"; exit;;
		1 )
			addFancyThings "-" "Running command ip a..."
			ip a;;
		2 )
			addFancyThings "-" "Running command date..."
			date;;
		3 ) addFancyThings "-" "Finding your home address..."
			echo -e "Using whoami, \$UID, and \$HOME, this is what I know."
			echo "Your user name is `whoami`, your user ID is $UID, and your home directory is $HOME";;
		4 ) addFancyThings "-" "Custom Date Options"
			# Create a new menu for determining special date stuff
			echo "Choose an option"
			echo "1. What day is today?"
			echo "2. What month is it?"
			echo "3. What year is it?"
			echo "4. Output the short date format."
			echo "5. Create a custom date string."
			echo -n "Enter a number from 1-5: "
			read dateInput
			case $dateInput in
				1 ) echo "Today is `date +%A` (date +%A)";;
				2 ) echo "This month is `date +%B` (date +%B)";;
				3 ) echo "This year is `date +%Y` (date +%Y)";;
				4 ) echo "Today is `date +%x` (date +%x or date +%m/%d/%y)";;
				5 ) echo "Enter a string using % followed by a letter" 
					read dateString
					echo "This is what you asked for: `date +$dateString`";;
				* ) echo "FATAL ERROR: PROGRAM CLOSING"; exit;;

			esac
			;;
		5 ) addFancyThings "-" "Ping an Address"
			echo -n "What IP address would you like to ping?: "
			read yourIP
			echo -n "How many times would you like to ping $yourIP ?: "
			read num
			addFancyThings "-" "Pinging $yourIP $num times..."
			ping -c $num $yourIP
			;;
		6 ) addFancyThings "-" "Counting on one hand..."
			echo "You've been sitting around in this program for $SECONDS seconds, or $[SECONDS/60] minutes";;
		7 ) addFancyThings "-" ""
			echo -n "What would you like the date file to be called? "
			read fileName
			fileName+=.txt
			date > $fileName
			echo "File successfully created. You can find $fileName in $(pwd)."
			;;
		8 ) addFancyThings "-" "Running find-prime-factors.sh"
			./find-prime-factors.sh
			;;
		9 ) addFancyThings "-" ""
			echo -n "Enter a number greater than 0: "
			read num
			echo "The Collatz sequence length of $num is $(./simpleCollatz.sh $num)"
			;;
		#10 ) addFancyThings "-" "The Factor Machine"
		#	echo "This calculator assumes the quadratic is in standard form"
		#	echo -n "Enter the a term of the quadratic: "
		#	read numA
		#	echo -n "Enter the b term of the quadratic: "
		#	read numB
		#	echo -n "Enter the c term of the quadratic: "
		#	read numC
		#	numX1=$(echo '(-1*$numB+sqrt(($numB^2)-4*$numA*$numC))/(2*$numA)' | bc -l)
		#	echo "One factor of the quadratic $numA(x^2)+$numB(x)+$numC is $numX1"
		#	;;
		10 ) addFancyThings "-" "N-th root calculator"
			echo -n "Enter the number you'd like to take the root of: "
			read num
			echo "Choose between the following options"
			echo "1. Square root of a number"
			echo "2. Other nth root of a number"
			echo -n "Select an option: "
			read selection
			case $selection in
				1 )
					square=$(echo "sqrt($num)" | bc -l)
					echo "The square root of $num is $square"
					;;
				2 )
					echo -n "Enter an integer n for the n-th root of $num: "
					read nPower
					root=$(echo "e(l($num)/$nPower)" | bc -l)
					echo "The $nPower-th root of $num is $root"
					;;
			esac;;
		* )
			echo "Invalid input. Press Enter to continue."; read; $0;;
	esac

	# Pause before going back to the beginning
	addFancyThings "*" "-- Press Enter to restart of Ctrl-C to exit --"
	read

done


