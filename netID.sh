#!/bin/bash
# Calculate the NetID based on IP and netmask

# Function from past bin-to-dec.sh assignment to convert binary numbers into decimal
# Used if netmask is given in the /xx or xx format rather than xxx.xxx.xxx.xxx
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

	for ((k=0;k<=$place;k++)); do	# iterates until it reaches value of place, meaning the index would equal zero
		# digit holds whether or not the value at the specified place is a 1 or a 0
		digit=${binNum:place-k:1}
		# decNum holds the final value of the conversion
		# takes the current value of decNum, and if the value is a 1, adds the power of 2 of the current place to decNum
		decNum=$[decNum+(placeValue*digit)]
		# increments placeValue to move to the next power of 2
		((placeValue*=2))
	done
	# call output
	echo $decNum
}

# Override IFS to seperate addresses on dots
oldIFS=$IFS

# Check for CLAs and populate IP and NetMask
if [[ $# -eq 0 ]]; then
	IFS="."
	echo -n "Enter your IP address: "
	read -a IP
	echo -n "Enter your Netmask: "
	read -a netmask
	IFS=$oldIFS
elif [[ $# -eq 1 ]]; then
	IFS="./"
	# Will give octects and subnet mask seperated into 5 elements of an array
	read -a input <<< $1
	# Prompts the user to provide a netmask if a netmask is not found to prevent errors
	if [[ ${#input} -ne 4 ]]; then
		echo -n "Please provide a Netmask: "
		read -a netmask
	else
		netmask=${input[@]:4:1}
	fi
	IP=${input[@]:0:4}
	IFS=$oldIFS
elif [[ $# -eq 2 ]]; then
	IFS="."
	read -a IP <<< $1 # <<< redirects as input
	read -a netmask <<< $2
	IFS=$oldIFS
fi # should now have two arrays with the info

# Conditional to trim off the slash if it was inputted into the netmask
if [[ ${netmask:0:1} = "/" ]]; then
	netmask=${netmask:1}
fi

# Conditional runs if netmask is in the /16, 16, or C format
# Converts to binary representation
if [[ ${#netmask[@]} -eq 1 ]]; then
	case $netmask in
		[aA] ) netmask=(255 0 0 0);;
		[bB] ) netmask=(255 255 0 0);;
		[cC] ) netmask=(255 255 255 0);;
		* ) echo "Error: not a network class name with an assigned subnet mask. Please try again."
			exit;;
	esac
elif [[ ${#netmask[@]} -eq 2 || ${#netmask[@]} -eq 1 ]]; then
	dot=0
	# Add ones where there are supposed to be ones for the subnet mask
	for ((i=1;i<=$netmask;i++)); do
		newNetmask+="1"
		((dot++))
		# Add periods to seperate the octets
		if [[ dot%8 -eq 0 ]]; then
			newNetmask+="."
		fi
	done
	for ((j=$netmask;j<32;j++)); do
		newNetmask+="0"
		((dot++))
		if [[ dot%8 -eq 0 ]]; then
			newNetmask+="."
		fi
	done
	IFS="."
	read -a netmask <<< $newNetmask
	IFS=$oldIFS
	for ((i=0;i<4;i++)); do
		netmask[i]=$(bin2dec ${netmask[i]})
	done
fi

# Debugging
#echo ${netmask[@]}

# Calculate NetID from IP and netmask
for ((i=0;i<4;i++)); do
	octet=${IP[i]}
	mask=${netmask[i]}
	network[i]=$[octet & mask] #bitwise AND
	#if [[ $mask -eq 255 ]]; then
	#	slash=$[slash+8]
	#else

	#fi
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
		* ) echo "The  subnet mask was entered incorrectly. Please reload the program."
			exit;;
	esac
done

echo "The Network ID of $1 is ${network[0]}.${network[1]}.${network[2]}.${network[3]}/$slash"

# In order to parse these types of inputs we need to add the / to IFS
# Input should also be able to look like this:
#./netID.sh 192.168.1.104/24
#	> 24
#	> /24
