#!/bin/bash
# Calculate the NetID based on IP and netmask

# Assuming the input looks like this:
#./netID.sh 192.168.1.104 255.255.255.0

# Override IFS to seperate addresses on dots
oldIFS=$IFS

# Check for CLAs and populate IP and NetMask
if [[ $# -eq 0 ]]; then
	IFS="."
	echo -n "Enter your IP address: "
	read -a IP
	echo -n "Enter your Netmask: "
	read -a netmask
	IFS=" "
elif [[ $# -eq 2 ]]; then
	IFS="."
	read -a IP <<< $1 # <<< redirects as input
	read -a netmask <<< $2
	#IP=$1
	#netmask=$2
	IFS=" "
fi # should now have two arrays with the info

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
done

echo "The Network ID is ${network[0]}.${network[1]}.${network[2]}.${network[3]}/$slash"

# Input should also be able to look like this:
#./netID.sh 192.168.1.104/24
#	> 24
#	> /24
