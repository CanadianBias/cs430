#!/bin/bash

# Calculates possible subnet configurations based on given IP and netmask
# Can calculate based on number of devices per network desired
# Can calculate based on number of networks desired
# Can print to the terminal or to a new file

# Function from utils.sh for adding borders
# Takes two parameters, the character to make the border, and the title (can be a blank string) to put in the middle
function addFancyThings {
	local char=$1
	local title=$2
	local titleLen=${#title}
	local stopPoint=$[(COLUMNS-titleLen)/2] # Creates a point to stop print characters so that the title can be aligned in the middle
	local line
	for ((i=0;i<$stopPoint;i++)); do # Add characters up to the stopping point
		line+=$char
	done
	line+=$title # Add title text
	for ((j=${#line};j<$COLUMNS;j++)); do # Add characters after the title until the length of the terminal
		line+=$char
	done
	echo $line
}

# Utilizes global variables
function convertNetmask {
#Convert slash notation to netmask
#Assumes slash is non-zero
#Convert slash notation to netmask
	for ((i=0;i<4;i++)); do
		if [[ $slash -ge 8 ]]; then # Reduces slash notation by 8, records the decimal netmask for that octet as 255
			netmask[$i]=255
			slash=$[slash-8]
		else
			case $slash in 
				0 ) netmask[i]=0;;
				1 ) netmask[i]=128;;
				2 ) netmask[i]=192;;
				3 ) netmask[i]=224;;
				4 ) netmask[i]=240;;
				5 ) netmask[i]=248;;
				6 ) netmask[i]=252;;
				7 ) netmask[i]=254;;
			esac
		slash=0 # Will rebuild slash later from decimal representation
		fi
	done
}

# Function that increments IP address by one
# Used to calculate subnet ranges
function incrementNetwork {
	placeholderNetwork[3]=$[${placeholderNetwork[3]}+1] # Adds one to the last octet of the IP address
	# Following nested conditionals used to increment each octet when it exceeds 255
	if [[ ${placeholderNetwork[3]} -gt 255 ]]; then
		placeholderNetwork[3]=0
		placeholderNetwork[2]=$[${placeholderNetwork[2]}+1]
		if [[ ${placeholderNetwork[2]} -gt 255 ]]; then
			placeholderNetwork[2]=0
			placeholderNetwork[1]=$[${placeholderNetwork[1]}+1]
			if [[ ${placeholderNetwork[1]} -gt 255 ]]; then
				placeholderNetwork[1]=0
				placeholderNetwork[0]=$[${placeholderNetwork[0]}+1]
				# No need to increment last octet, as it should never exceed 255
			fi
		fi
	fi
}

# Function to choose whether to subnet based on desired bits or desired networks
# Two if statements that define the same global variables but in different orders
# Both call the function calculateSubnetNetmask that reuses the variable option
# Function is called again if incorrect input is recieved
function selectSubnetOption {
	echo "Would you like to subnet this network based on networks (1) or devices (2) ?"
	echo -n "(1/2): "
	read option

	if [[ $option -eq 1 ]]; then
		# Prompt for amount of networks desired
		echo -n "How many networks are desired: "
		read numNetworks

		# Determine bitsNeeded for that amount of networks
		subnetBitsNeeded=$(bc -l <<< "(l($numNetworks)/l(2))")
		subnetBitsNeeded=$(gawk -v bits=$subnetBitsNeeded 'BEGIN{x=int(bits); print x}') # Floors to nearest integer

		# Conditional increments amount of bits needed by 1 if not exactly equal to amount of networks requested
		if [[ $[2**subnetBitsNeeded] -ne $numNetworks ]]; then
			((subnetBitsNeeded++))
		fi

		# Calls function to calculate decimal represenation of netmask
		# Calculate if bits are available on current network
		calculateSubnetNetmask

		# Determine new netmask, slash, IP ranges, and number of devices per network

	elif [[ $option -eq 2 ]]; then
		echo -n "At least how many devices would you like each network to have: "
		read num

		# Calculates how many bits are needed for device IDs, reserving two IPs for network ID and broadcast
		deviceBitsNeeded=$(bc -l <<< "(l($num+2)/l(2))") # Calculates number of bits needed in float point form
		deviceBitsNeeded=$(gawk -v bits=$deviceBitsNeeded 'BEGIN{x=int(bits); print x}') # Floors to nearest integer

		# Conditional increments amount of bits needed by 1 if not exactly equal to amount of devices requested
		if [[ $[2**deviceBitsNeeded-2] -ne $num ]]; then
			((deviceBitsNeeded++))
		fi

		# Function call
		calculateSubnetNetmask
	else
		selectSubnetOption # Reruns program if incorrect input recieved
	fi
}

# Function to confirm proper amount of bits are available in subnet 
# Calculates decimal representation of new subnet netmask
function calculateSubnetNetmask {

	# Conditional checking to see what option selection this was called from
	if [[ $option -eq 1 ]]; then
		deviceBitsNeeded=$[32-slash-subnetBitsNeeded]
	elif [[ $option -eq 2 ]]; then
		subnetBitsNeeded=$[32-slash-deviceBitsNeeded]
	fi

	# Makes sure bits are available
	if [[ $subnetBitsNeeded -lt 0 ]]; then
		echo "Error - insufficient space in original netmask for this many devices."
		selectSubnetOption
	elif [[ $subnetBitsNeeded -eq 0 ]]; then
		echo "Error - current network already has a maximum of $num devices."
		selectSubnetOption
	elif [[ $deviceBitsNeeded -lt 1 ]]; then
		echo "Error - not able to create this many subnets, not enough address space"
		selectSubnetOption
	elif [[ $deviceBitsNeeded -eq 1 ]]; then
		echo "Error - subnet able to be created, but no addresses available for device"
		selectSubnetOption
	else

		addFancyThings "-" "Calculating Subnet Netmask"

		# Moved inside error checking to prevent negative exponent errors if invalid number entered for devices/networks
		# Checks option again to calculate variables needed down below
		if [[ $option -eq 1 ]]; then
			deviceBitsNeeded=$[32-slash-subnetBitsNeeded]
			numNetworks=$[2**subnetBitsNeeded]
			numDevices=$[2**deviceBitsNeeded-2]
		elif [[ $option -eq 2 ]]; then
			subnetBitsNeeded=$[32-slash-deviceBitsNeeded]
			numNetworks=$[2**subnetBitsNeeded]
			numDevices=$[2**deviceBitsNeeded-2]
		fi

		# Calculate new slash, create placeholder to calcuate decimal representation of subnet netmask
		subnetSlash=$[slash+subnetBitsNeeded]
		placeholderSlash=$subnetSlash

		# Modified code from convertNetmask to calculate decimal subnet netmask
		for ((i=0;i<4;i++)); do
			if [[ $placeholderSlash -ge 8 ]]; then
				subnetNetmask[$i]=255
				placeholderSlash=$[placeholderSlash-8]
			else
				case $placeholderSlash in 
					0 ) subnetNetmask[i]=0;;
					1 ) subnetNetmask[i]=128;;
					2 ) subnetNetmask[i]=192;;
					3 ) subnetNetmask[i]=224;;
					4 ) subnetNetmask[i]=240;;
					5 ) subnetNetmask[i]=248;;
					6 ) subnetNetmask[i]=252;;
					7 ) subnetNetmask[i]=254;;
				esac
			placeholderSlash=0
			fi
		done

		# Gives preview of subnetting information
		echo "Subnetting ${network[0]}.${network[1]}.${network[2]}.${network[3]}/$slash would return $numNetworks networks with $numDevices devices each and a new netmask of ${subnetNetmask[0]}.${subnetNetmask[1]}.${subnetNetmask[2]}.${subnetNetmask[3]}"
	fi
}

# Allows the user to decide if they would prefer raw output to the terminal or create a new file in their working directory
function selectSaveOption {
	echo "Would you like to print the subnet information to the terminal (1) or write it to a file (2) ?"
	echo -n "(1/2): "
	read saveOption

	# Conditional to handle incorrect input
	if [[ $saveOption -eq 1 ]]; then
		printToCLI # function call to print to terminal
	elif [[ $saveOption -eq 2 ]]; then
		printToFile # function call to write to file
	else
		echo "An error occurred, please select an option"
		selectSaveOption
	fi
}

# Calculates subnet addresses, ranges, and broadcasts
# Prints them to the current terminal
function printToCLI {
	addFancyThings "-" "Printing Subnet List to Terminal"
	# Determining subnet network IDs, ranges, and broadcasts
	# Could there be a more efficient way to split the IP ranges?
	placeholderNetwork=("${network[@]}")
	for ((i=1;i<=$numNetworks;i++)); do
		echo "Network $i ID: ${placeholderNetwork[0]}.${placeholderNetwork[1]}.${placeholderNetwork[2]}.${placeholderNetwork[3]}/$subnetSlash"
		# Increment placeholderNetwork by 1 to start recording range of device IDs
		# Needs conditional to prevent going over 255 for each octet
		incrementNetwork
		echo "Network $i Address Range Start: ${placeholderNetwork[0]}.${placeholderNetwork[1]}.${placeholderNetwork[2]}.${placeholderNetwork[3]}"
		# Increment placeholderNetwork by numDevices to find range
		for ((j=1;j<$numDevices;j++)); do
			incrementNetwork
		done
		echo "Network $i Address Range End: ${placeholderNetwork[0]}.${placeholderNetwork[1]}.${placeholderNetwork[2]}.${placeholderNetwork[3]}"
		# Increment placeholderNetwork to find broadcast IP for that subnetted network
		incrementNetwork
		echo "Network $i Broadcast ID: ${placeholderNetwork[0]}.${placeholderNetwork[1]}.${placeholderNetwork[2]}.${placeholderNetwork[3]}"
		
		# Increment placeholderNetwork by one to prepare for next network to be recorded
		incrementNetwork
		# Run next iteration of loop
	done
	addFancyThings "-" "End of Subnet Information"
}

# Calculates subnet addresses, ranges, and broadcasts
# Writes it to a new file with the name and extension of the user's choice
function printToFile {
	echo -n "What would you like the new file containing the subnet information to be called: " # prompt user for new file name
	read fileName

	# Format sourced from https://sentry.io/answers/determine-whether-a-file-exists-or-not-in-bash/ 
	if test -f $fileName; then # checks if a similarly named file already exists in this location 
		echo "Error - file already exists. Please choose a different file name."
		printToFile
	else
		touch $fileName # creates new file
		exec 3>&1 1>$fileName # stores STDOUT info to placeholder, assigns STDOUT to new file
		# header of sorts, prints general information about the initial network and subnet information
		echo "Network ID: ${network[0]}.${network[1]}.${network[2]}.${network[3]}/$slash" >&1
		echo "Netmask: ${netmask[0]}.${netmask[1]}.${netmask[2]}.${netmask[3]}" >&1
		echo "Subnetting ${network[0]}.${network[1]}.${network[2]}.${network[3]}/$slash would return $numNetworks networks with $numDevices devices each and a new netmask of ${subnetNetmask[0]}.${subnetNetmask[1]}.${subnetNetmask[2]}.${subnetNetmask[3]}" >&1

		# placeholder to preserve original network
		placeholderNetwork=("${network[@]}")
		# Loop that creates network information for each subnet
		for ((i=1;i<=$numNetworks;i++)); do
			echo "Network $i ID: ${placeholderNetwork[0]}.${placeholderNetwork[1]}.${placeholderNetwork[2]}.${placeholderNetwork[3]}/$subnetSlash" >&1
			# Increment placeholderNetwork by 1 to start recording range of device IDs
			# Needs conditional to prevent going over 255 for each octet
			incrementNetwork
			echo "Network $i Address Range Start: ${placeholderNetwork[0]}.${placeholderNetwork[1]}.${placeholderNetwork[2]}.${placeholderNetwork[3]}" >&1
			# Increment placeholderNetwork by numDevices to find range
			for ((j=1;j<$numDevices;j++)); do
				incrementNetwork
			done
			echo "Network $i Address Range End: ${placeholderNetwork[0]}.${placeholderNetwork[1]}.${placeholderNetwork[2]}.${placeholderNetwork[3]}" >&1
			# Increment placeholderNetwork to find broadcast IP for that subnetted network
			incrementNetwork
			echo "Network $i Broadcast ID: ${placeholderNetwork[0]}.${placeholderNetwork[1]}.${placeholderNetwork[2]}.${placeholderNetwork[3]}" >&1
			
			# Increment placeholderNetwork by one to prepare for next network to be recorded
			incrementNetwork
			# Run next iteration of loop
		done
		exec 1>&3 3>&- # Returns STDOUT back to the current program
	fi
	echo "Created $fileName in $PWD." # Confirms to the user that the file has been created
}

clear

addFancyThings "=" "Subnet Calculator"

# Override IFS to seperate addresses on dots
oldIFS=$IFS

# Check for CLAs and populate IP and NetMask
if [[ $# -eq 0 ]]; then
	IFS="."
	echo -n "Enter your IP address: "
	read -a IP
	echo -n "Enter your Netmask: "
	read netmaskInput
	case $netmaskInput in
		255.*.*.* ) read -a netmask <<< $netmaskInput;;
		/* ) slash=${2:1}
			#Convert slash notation to netmask
			convertNetmask;;
		[0-9] | [0-3][0-9] | 30 ) slash=$netmaskInput
			#Convert slash notation to netmask
			convertNetmask;;
		[aAbBcC] ) case $netmaskInput in
				[aA] ) slash=8;;
				[bB] ) slash=16;;
				[cC] ) slash=24;;
			esac
			convertNetmask;;
	esac
	IFS=$oldIFS
# The elif below needs error checking:
	# Did they give me an IP, netmask, IP/bits?
	# What do I do with what they gave me
elif [[ $# -eq 1 ]]; then
	case $1 in
		*.*.*.*/* ) IFS="./"
			read -a IP <<< $1 # given both the IP and slash, need to convertNetmask to get binary
			IFS=$oldIFS
			slash=${IP[4]}
			convertNetmask;;
		255.*.*.* ) IFS="." # if the only CLA given is a netmask, prompt for an IP
			read -a netmask <<< $1
			echo -n "Enter your IP address: "
			read -a IP
			IFS=$oldIFS;;
		*.*.*.* ) IFS="." # only given IP, prompt for netmask
			read -a IP <<< $1
			echo -n "Enter your Netmask: "
			read netmaskInput
			case $netmaskInput in # parse netmask input into proper format
				255.*.*.* )
					read -a netmask <<< $netmaskInput;;
				/* ) 
					slash=${2:1}
					#Convert slash notation to netmask
					convertNetmask;;
				[0-9] | [0-3][0-9] | 30 ) slash=$netmaskInput
					#Convert slash notation to netmask
					convertNetmask;;
				[aAbBcC] ) 
					case $netmaskInput in
						[aA] ) slash=8;;
						[bB] ) slash=16;;
						[cC] ) slash=24;;
					esac
					convertNetmask;;
			esac
			IFS=$oldIFS;;
	esac
	IFS=$oldIFS
elif [[ $# -eq 2 ]]; then
	IFS="."
	read -a IP <<< $1 # <<< redirects as input
	# Dr. Elliot's in-class example (that's probably better than mine)
		case $2 in
		255.*.*.* ) read -a netmask <<< $2;;
		/* ) slash=${2:1}
			#Convert slash notation to netmask
			convertNetmask;;
		[0-9] | [0-3][0-9] | 30 ) slash=$2
			#Convert slash notation to netmask
			convertNetmask;;
		[aAbBcC] ) case $2 in
			[aA] ) slash=8;;
			[bB] ) slash=16;;
			[cC] ) slash=24;;
			esac
			convertNetmask;;
	esac
	IFS=$oldIFS
elif [[ $# -gt 2 ]]; then
	./subnetCalc.sh # if there are too many CLAs given, restart whole process
fi # should now have two arrays with the info

# Calculate NetID from IP and netmask
for ((i=0;i<4;i++)); do
	octet=${IP[i]}
	mask=${netmask[i]}
	network[i]=$[octet & mask] #bitwise AND

	# error checking to prevent incorrect IP information from being inputted and causing errors
	if ! [[ $octet =~ ^[0-9]{,3}$ ]]; then
		echo "The IP address was entered incorrectly. Press Enter to continue."
		read
		./subnetCalc.sh
	elif [[ $octet -lt 0 || $octet -gt 255 ]]; then
		echo "The IP address was entered incorrectly. Press Enter to continue."
		read
		./subnetCalc.sh
	fi

	# Case statement to convert netmask to slash notation, and to check for errors in netmask
	case $mask in
		255 ) slash=$[slash+8];;
		254 ) slash=$[slash+7];;
		252 ) slash=$[slash+6];;
		248 ) slash=$[slash+5];;
		240 ) slash=$[slash+4];;
		224 ) slash=$[slash+3];;
		192 ) slash=$[slash+2];;
		128 ) slash=$[slash+1];;
		0 ) slash=$[slash];;
		* ) echo "The netmask was entered incorrectly. Press Enter to continue." # handles errors in the netmask
		read
		./subnetCalc.sh;;
	esac
done

# Calculates number of IP addresses available under the original network
origAddresses=$[2**(32-slash)]

addFancyThings "-" "Calculating Network ID"

# Network ID and previewing amount of devices on network to help subnetting
echo "Network ID: ${network[0]}.${network[1]}.${network[2]}.${network[3]}/$slash"
echo "Netmask: ${netmask[0]}.${netmask[1]}.${netmask[2]}.${netmask[3]}"
echo "# of available addresses on this network: $[origAddresses-2]" 

addFancyThings "-" ""

# Function call to begin the subnetting process
selectSubnetOption

# Function call for saving subnet configuration to a file or printing to CLI
selectSaveOption

addFancyThings "=" "End of Subnet Calculator"

# Gives user option to restart or exit program
IFS=" "
echo "Would you like to restart the program (1) or exit (2) ?"
echo -n "(1/2): "
read exitInput
case $exitInput in
	1 ) ./subnetCalc.sh
	;;
	2 ) ;;
	* ) echo "Error - exiting program...";; # Causes program to exit on any input not recognized
esac
	
